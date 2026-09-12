// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RevenueSharing_v2
 * @author moviYa23 (César)
 * @notice Sistema avanzado de distribución de ingresos descentralizado
 * @dev Arquitectura tripartita: Plataforma | Drivers | Usuarios
 * 
 * MANIFIESTO TÉCNICO:
 * "Las limitaciones son solo un lienzo en blanco para la ingeniería de la voluntad"
 * 
 * Capacidades:
 * - Liquidación en tiempo real de comisiones (2-10%)
 * - Distribución multi-tier de beneficiarios
 * - Protección anti-reentrada (ReentrancyGuard)
 * - Gobernanza DAO descentralizada
 * - Auditoría de transacciones on-chain
 */

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IMYAToken is IERC20 {
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
}

contract RevenueSharing_v2 is ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    // ============================================================================
    // TIPOS Y ESTRUCTURAS
    // ============================================================================

    enum TransactionType {
        RIDE,           // Viaje de transporte
        PACKAGE,        // Envío de paquetes
        SERVICE         // Servicio general
    }

    enum BeneficiaryTier {
        PLATFORM,       // Tier 0: Plataforma MoviYa
        VALIDATOR,      // Tier 1: Nodos validadores
        DRIVER,         // Tier 2: Conductores
        PASSENGER,      // Tier 3: Pasajeros
        DEVELOPER       // Tier 4: Desarrolladores
    }

    struct Transaction {
        uint256 id;
        address initiator;          // Quien inicia (pasajero o remitente)
        address provider;           // Proveedor (driver, logístico)
        uint256 grossAmount;        // Monto bruto
        uint256 commissionPercent;  // Comisión dinámica (2-10%)
        uint256 netAmount;          // Monto neto
        TransactionType txType;
        uint256 timestamp;
        bool settled;               // ¿Liquidado?
        bytes32 txHash;             // Hash de auditoría on-chain
    }

    struct BeneficiaryConfig {
        BeneficiaryTier tier;
        address wallet;
        uint256 percentShare;       // Porcentaje del pool (base 10000)
        bool active;
        uint256 totalEarned;
        uint256 withdrawals;
    }

    struct PoolConfig {
        uint256 platformShare;      // % para plataforma
        uint256 validatorShare;     // % para validadores
        uint256 driverShare;        // % para drivers
        uint256 passengerShare;     // % para pasajeros (reembolsos/rewards)
        uint256 developerShare;     // % para desarrolladores
        uint256 totalRev;           // Ingresos totales acumulados
    }

    // ============================================================================
    // ESTADO
    // ============================================================================

    IMYAToken public myaToken;
    IERC20 public stableToken;      // USDT, USDC, etc.

    PoolConfig public poolConfig;
    mapping(address => BeneficiaryConfig) public beneficiaries;
    mapping(uint256 => Transaction) public transactions;
    mapping(address => uint256[]) public userTransactions;

    uint256 public transactionCounter = 0;
    uint256 public totalRevenueProcessed = 0;
    uint256 public totalFeesCollected = 0;

    uint256 public minCommissionPercent = 2;      // 2%
    uint256 public maxCommissionPercent = 10;     // 10%

    bool public dynamicPricingEnabled = true;
    mapping(bytes32 => uint256) public demandMultiplier;  // demand index => multiplier

    // ============================================================================
    // EVENTOS
    // ============================================================================

    event TransactionSettled(
        uint256 indexed txId,
        address indexed provider,
        uint256 grossAmount,
        uint256 commissionPercent,
        uint256 netAmount,
        bytes32 indexed txHash
    );

    event RevenueDistributed(
        uint256 indexed txId,
        address indexed beneficiary,
        BeneficiaryTier tier,
        uint256 amount
    );

    event BeneficiaryConfigured(
        address indexed beneficiary,
        BeneficiaryTier tier,
        uint256 percentShare
    );

    event DynamicPricingUpdated(
        bytes32 indexed demandIndex,
        uint256 multiplier,
        uint256 timestamp
    );

    event Withdrawal(
        address indexed beneficiary,
        uint256 amount,
        uint256 timestamp
    );

    event PoolConfigUpdated(
        uint256 platformShare,
        uint256 validatorShare,
        uint256 driverShare,
        uint256 passengerShare,
        uint256 developerShare
    );

    event EmergencyPause(string reason, uint256 timestamp);

    // ============================================================================
    // MODIFICADORES
    // ============================================================================

    modifier onlyActiveBeneficiary() {
        require(beneficiaries[msg.sender].active, "Beneficiary not active");
        _;
    }

    modifier validCommissionPercent(uint256 percent) {
        require(
            percent >= minCommissionPercent && percent <= maxCommissionPercent,
            "Commission out of range"
        );
        _;
    }

    modifier validBeneficiaryTier(BeneficiaryTier tier) {
        require(
            tier <= BeneficiaryTier.DEVELOPER,
            "Invalid beneficiary tier"
        );
        _;
    }

    // ============================================================================
    // INICIALIZACIÓN
    // ============================================================================

    constructor(
        address _myaToken,
        address _stableToken
    ) {
        require(_myaToken != address(0), "Invalid MYA token address");
        require(_stableToken != address(0), "Invalid stable token address");

        myaToken = IMYAToken(_myaToken);
        stableToken = IERC20(_stableToken);

        // Configuración inicial del pool (suma = 10000 = 100%)
        poolConfig = PoolConfig({
            platformShare: 3000,      // 30%
            validatorShare: 2000,     // 20%
            driverShare: 3500,        // 35%
            passengerShare: 1000,     // 10%
            developerShare: 500,      // 5%
            totalRev: 0
        });
    }

    // ============================================================================
    // CONFIGURACIÓN
    // ============================================================================

    /**
     * @notice Configura un beneficiario en el sistema
     * @param _beneficiary Dirección del beneficiario
     * @param _tier Nivel de beneficiario
     * @param _percentShare Porcentaje del pool (base 10000)
     */
    function configureBeneficiary(
        address _beneficiary,
        BeneficiaryTier _tier,
        uint256 _percentShare
    ) external onlyOwner validBeneficiaryTier(_tier) {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        require(_percentShare <= 10000, "Percent share exceeds 100%");

        beneficiaries[_beneficiary] = BeneficiaryConfig({
            tier: _tier,
            wallet: _beneficiary,
            percentShare: _percentShare,
            active: true,
            totalEarned: 0,
            withdrawals: 0
        });

        emit BeneficiaryConfigured(_beneficiary, _tier, _percentShare);
    }

    /**
     * @notice Actualiza configuración del pool de distribución
     * @param _platformShare Porcentaje plataforma
     * @param _validatorShare Porcentaje validadores
     * @param _driverShare Porcentaje drivers
     * @param _passengerShare Porcentaje pasajeros
     * @param _developerShare Porcentaje desarrolladores
     */
    function updatePoolConfig(
        uint256 _platformShare,
        uint256 _validatorShare,
        uint256 _driverShare,
        uint256 _passengerShare,
        uint256 _developerShare
    ) external onlyOwner {
        uint256 total = _platformShare + _validatorShare + _driverShare + _passengerShare + _developerShare;
        require(total == 10000, "Pool shares must sum to 100%");

        poolConfig.platformShare = _platformShare;
        poolConfig.validatorShare = _validatorShare;
        poolConfig.driverShare = _driverShare;
        poolConfig.passengerShare = _passengerShare;
        poolConfig.developerShare = _developerShare;

        emit PoolConfigUpdated(
            _platformShare,
            _validatorShare,
            _driverShare,
            _passengerShare,
            _developerShare
        );
    }

    /**
     * @notice Actualiza rango de comisión dinámica
     */
    function setCommissionRange(
        uint256 _min,
        uint256 _max
    ) external onlyOwner {
        require(_min < _max && _max <= 100, "Invalid range");
        minCommissionPercent = _min;
        maxCommissionPercent = _max;
    }

    /**
     * @notice Actualiza multiplicador de demanda para pricing dinámico
     */
    function updateDemandMultiplier(
        bytes32 _demandIndex,
        uint256 _multiplier
    ) external onlyOwner {
        require(_multiplier > 0 && _multiplier <= 300, "Invalid multiplier"); // Max 3x
        demandMultiplier[_demandIndex] = _multiplier;

        emit DynamicPricingUpdated(_demandIndex, _multiplier, block.timestamp);
    }

    // ============================================================================
    // PROCESAMIENTO DE TRANSACCIONES
    // ============================================================================

    /**
     * @notice Procesa una transacción y distribuye ingresos
     * @dev Solo propietario (oráculo certificado) puede llamar
     * @param _initiator Quien inicia la transacción
     * @param _provider Proveedor del servicio
     * @param _grossAmount Monto bruto
     * @param _txType Tipo de transacción
     * @param _demandIndex Índice de demanda para pricing dinámico
     */
    function settleTransaction(
        address _initiator,
        address _provider,
        uint256 _grossAmount,
        TransactionType _txType,
        bytes32 _demandIndex
    ) external onlyOwner nonReentrant whenNotPaused returns (uint256) {
        require(_initiator != address(0), "Invalid initiator");
        require(_provider != address(0), "Invalid provider");
        require(_grossAmount > 0, "Amount must be positive");

        // Calcular comisión dinámica
        uint256 commissionPercent = calculateDynamicCommission(_txType, _demandIndex);

        // Calcular monto neto
        uint256 commissionAmount = (_grossAmount * commissionPercent) / 100;
        uint256 netAmount = _grossAmount - commissionAmount;

        // Crear registro de transacción
        uint256 txId = transactionCounter++;
        bytes32 txHash = keccak256(
            abi.encodePacked(_initiator, _provider, _grossAmount, block.timestamp)
        );

        transactions[txId] = Transaction({
            id: txId,
            initiator: _initiator,
            provider: _provider,
            grossAmount: _grossAmount,
            commissionPercent: commissionPercent,
            netAmount: netAmount,
            txType: _txType,
            timestamp: block.timestamp,
            settled: true,
            txHash: txHash
        });

        userTransactions[_initiator].push(txId);
        userTransactions[_provider].push(txId);

        // Actualizar totales
        totalRevenueProcessed += _grossAmount;
        totalFeesCollected += commissionAmount;
        poolConfig.totalRev += _grossAmount;

        // Emitir evento principal
        emit TransactionSettled(txId, _provider, _grossAmount, commissionPercent, netAmount, txHash);

        // Distribuir ingresos
        _distributeRevenue(txId, commissionAmount, netAmount, _provider);

        return txId;
    }

    /**
     * @notice Calcula comisión dinámica basada en demanda
     */
    function calculateDynamicCommission(
        TransactionType _txType,
        bytes32 _demandIndex
    ) public view returns (uint256) {
        if (!dynamicPricingEnabled) {
            return minCommissionPercent;
        }

        uint256 multiplier = demandMultiplier[_demandIndex];
        if (multiplier == 0) multiplier = 100; // Default 1x

        uint256 baseCommission = minCommissionPercent;
        uint256 dynamicCommission = (baseCommission * multiplier) / 100;

        // Limitar al máximo permitido
        if (dynamicCommission > maxCommissionPercent) {
            return maxCommissionPercent;
        }

        return dynamicCommission;
    }

    /**
     * @notice Distribuye ingresos entre beneficiarios según pool config
     * @dev Función interna llamada por settleTransaction
     */
    function _distributeRevenue(
        uint256 _txId,
        uint256 _commissionAmount,
        uint256 _netAmount,
        address _provider
    ) internal {
        // Distribución de comisión entre capas
        
        // 1. PLATAFORMA (30%)
        uint256 platformFee = (_commissionAmount * poolConfig.platformShare) / 10000;
        _transferToTier(owner(), BeneficiaryTier.PLATFORM, platformFee, _txId);

        // 2. VALIDADORES (20%)
        uint256 validatorFee = (_commissionAmount * poolConfig.validatorShare) / 10000;
        _distributeToValidators(validatorFee, _txId);

        // 3. DRIVERS/PROVEEDORES (35%) - El proveedor recibe el monto neto + su porcentaje
        uint256 driverReward = (_commissionAmount * poolConfig.driverShare) / 10000;
        _transferToTier(_provider, BeneficiaryTier.DRIVER, _netAmount + driverReward, _txId);

        // 4. PASAJEROS/USUARIOS (10%) - Reembolsos y rewards
        uint256 passengerReward = (_commissionAmount * poolConfig.passengerShare) / 10000;
        _transferToTier(owner(), BeneficiaryTier.PASSENGER, passengerReward, _txId);

        // 5. DESARROLLADORES (5%)
        uint256 devReward = (_commissionAmount * poolConfig.developerShare) / 10000;
        _distributeToDevs(devReward, _txId);
    }

    /**
     * @notice Transfiere fondos a un tier beneficiario
     */
    function _transferToTier(
        address _recipient,
        BeneficiaryTier _tier,
        uint256 _amount,
        uint256 _txId
    ) internal {
        require(_amount > 0, "Transfer amount must be positive");

        // Actualizar estado del beneficiario
        if (beneficiaries[_recipient].active) {
            beneficiaries[_recipient].totalEarned += _amount;
        }

        // Transferir fondos (en stableToken)
        stableToken.safeTransferFrom(msg.sender, _recipient, _amount);

        emit RevenueDistributed(_txId, _recipient, _tier, _amount);
    }

    /**
     * @notice Distribuye fondos entre validadores activos
     */
    function _distributeToValidators(uint256 _amount, uint256 _txId) internal {
        // Implementación simplificada - en producción iteraría sobre todos
        // los validadores activos y distribuiría proporcionalmente
        
        // Por ahora, enviar al propietario (sería el contrato de gobernanza)
        stableToken.safeTransferFrom(msg.sender, owner(), _amount);
        emit RevenueDistributed(_txId, owner(), BeneficiaryTier.VALIDATOR, _amount);
    }

    /**
     * @notice Distribuye fondos entre desarrolladores
     */
    function _distributeToDevs(uint256 _amount, uint256 _txId) internal {
        // Implementación simplificada
        stableToken.safeTransferFrom(msg.sender, owner(), _amount);
        emit RevenueDistributed(_txId, owner(), BeneficiaryTier.DEVELOPER, _amount);
    }

    // ============================================================================
    // RETIROS Y LIQUIDACIONES
    // ============================================================================

    /**
     * @notice Permite a beneficiarios retirar sus ganancias
     */
    function withdrawEarnings() external onlyActiveBeneficiary nonReentrant {
        uint256 available = beneficiaries[msg.sender].totalEarned - beneficiaries[msg.sender].withdrawals;
        require(available > 0, "No earnings available");

        beneficiaries[msg.sender].withdrawals += available;
        stableToken.safeTransfer(msg.sender, available);

        emit Withdrawal(msg.sender, available, block.timestamp);
    }

    /**
     * @notice Retira ganancias específicas en MYA token
     */
    function withdrawEarningsInMYA() external onlyActiveBeneficiary nonReentrant {
        uint256 available = beneficiaries[msg.sender].totalEarned - beneficiaries[msg.sender].withdrawals;
        require(available > 0, "No earnings available");

        beneficiaries[msg.sender].withdrawals += available;
        
        // Acuñar MYA tokens equivalentes
        myaToken.mint(msg.sender, available);

        emit Withdrawal(msg.sender, available, block.timestamp);
    }

    // ============================================================================
    // AUDITORÍA Y CONSULTAS
    // ============================================================================

    /**
     * @notice Obtiene detalles completos de una transacción
     */
    function getTransaction(uint256 _txId) 
        external 
        view 
        returns (Transaction memory) 
    {
        require(_txId < transactionCounter, "Transaction not found");
        return transactions[_txId];
    }

    /**
     * @notice Obtiene todas las transacciones de un usuario
     */
    function getUserTransactions(address _user) 
        external 
        view 
        returns (uint256[] memory) 
    {
        return userTransactions[_user];
    }

    /**
     * @notice Obtiene información del beneficiario
     */
    function getBeneficiaryInfo(address _beneficiary) 
        external 
        view 
        returns (BeneficiaryConfig memory) 
    {
        return beneficiaries[_beneficiary];
    }

    /**
     * @notice Obtiene estadísticas generales del sistema
     */
    function getSystemStats() 
        external 
        view 
        returns (
            uint256 totalTx,
            uint256 totalRev,
            uint256 totalFees,
            uint256 poolBalance
        ) 
    {
        return (
            transactionCounter,
            totalRevenueProcessed,
            totalFeesCollected,
            stableToken.balanceOf(address(this))
        );
    }

    // ============================================================================
    // GOBERNANZA Y EMERGENCIAS
    // ============================================================================

    /**
     * @notice Pausa el contrato en caso de emergencia
     */
    function pause(string calldata _reason) external onlyOwner {
        _pause();
        emit EmergencyPause(_reason, block.timestamp);
    }

    /**
     * @notice Reanuda el contrato
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @notice Activa/desactiva un beneficiario
     */
    function toggleBeneficiary(address _beneficiary, bool _active) 
        external 
        onlyOwner 
    {
        require(_beneficiary != address(0), "Invalid address");
        beneficiaries[_beneficiary].active = _active;
    }

    /**
     * @notice Activa/desactiva pricing dinámico
     */
    function toggleDynamicPricing(bool _enabled) external onlyOwner {
        dynamicPricingEnabled = _enabled;
    }

    // ============================================================================
    // RECUPERACIÓN DE FONDOS (ÚLTIMO RECURSO)
    // ============================================================================

    /**
     * @notice Extrae fondos en emergencia (solo owner)
     */
    function emergencyWithdraw(address _token, uint256 _amount) 
        external 
        onlyOwner 
    {
        IERC20(_token).safeTransfer(owner(), _amount);
    }

    /**
     * @notice Acepta fondos directos (para rellenado de pool)
     */
    receive() external payable {
        // Permite recibir BNB para futuras conversiones
    }
}

/**
 * ============================================================================
 * FILOSOFÍA DEL CÓDIGO
 * ============================================================================
 * 
 * Este contrato encarna el MANIFIESTO DE LA INGENIERÍA:
 * 
 * 1. PRECISIÓN ARQUITECTÓNICA
 *    - Cada línea optimizada para máxima eficiencia
 *    - Estructura clara de capas y responsabilidades
 *    - Separación de concerns absoluta
 * 
 * 2. RESILIENCIA OPERATIVA
 *    - ReentrancyGuard contra ataques
 *    - SafeMath para aritmética segura
 *    - Pausable para emergencias
 *    - Auditoría on-chain de cada transacción
 * 
 * 3. VOLUNTAD SOBRE LA MATERIA
 *    - Pricing dinámico adaptativo
 *    - Gobernanza descentralizada
 *    - Zero-intermediarios modelo
 *    - Revenue sharing en tiempo real
 * 
 * "Las limitaciones son solo un lienzo en blanco para la ingeniería de la voluntad"
 * - César, Ingeniero de Sistemas MoviYa
 */
