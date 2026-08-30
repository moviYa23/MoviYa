// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title MoviYangToken
 * @dev Token ERC-20 de MoviYa con funcionalidades de Revenue Sharing y recompensas
 * @notice Emite tokens MYT automáticamente en cada transacción completada
 */
contract MoviYangToken is ERC20, Ownable, Pausable, ERC20Burnable {
    // ============================================
    // STATE VARIABLES
    // ============================================

    /// @dev Cantidad total de tokens acuñados
    uint256 public totalTokensMinted;

    /// @dev Cantidad total distribuida a holders
    uint256 public totalDistributed;

    /// @dev Tarifa de distribución (en basis points, e.g., 100 = 1%)
    uint256 public distributionFeePercentage = 150; // 1.5%

    /// @dev Dirección del contrato de pagos
    address public paymentsContract;

    /// @dev Última vez que se distribuyeron recompensas
    uint256 public lastDistributionTime;

    /// @dev Intervalo mínimo entre distribuciones (en segundos)
    uint256 public constant DISTRIBUTION_INTERVAL = 1 days;

    // ============================================
    // MAPPINGS
    // ============================================

    /// @dev Rastrear contribuciones de desarrolladores
    mapping(address => uint256) public developerContributions;

    /// @dev Rastrear puntos de fidelización de usuarios
    mapping(address => uint256) public userLoyaltyPoints;

    /// @dev Rastrear nivel VIP de usuarios
    mapping(address => uint8) public userVIPLevel;

    /// @dev Rastrear transacciones completadas por usuario
    mapping(address => uint256) public userTransactionCount;

    // ============================================
    // EVENTS
    // ============================================

    event TokensMintedForTransaction(
        address indexed user,
        uint256 amount,
        uint256 transactionId
    );

    event RevenueDistributed(
        uint256 totalAmount,
        uint256 holdersShare,
        uint256 developersShare
    );

    event LoyaltyPointsEarned(
        address indexed user,
        uint256 points,
        uint256 newBalance
    );

    event VIPLevelChanged(
        address indexed user,
        uint8 oldLevel,
        uint8 newLevel
    );

    event DeveloperContributionRecorded(
        address indexed developer,
        uint256 amount,
        string contributionType
    );

    // ============================================
    // CONSTRUCTOR
    // ============================================

    constructor() ERC20("MoviYang Token", "MYT") {
        // Acuñar 1 millón de tokens iniciales (para liquidez del protocolo)
        _mint(msg.sender, 1_000_000 * 10 ** 18);
        totalTokensMinted = 1_000_000 * 10 ** 18;
        lastDistributionTime = block.timestamp;
    }

    // ============================================
    // MINT FUNCTIONS - Acuñar tokens por transacciones
    // ============================================

    /**
     * @dev Acuñar tokens de recompensa después de una transacción exitosa
     * @param user Dirección del usuario
     * @param amount Cantidad de tokens a acuñar
     * @param transactionId ID de la transacción en MoviYa
     */
    function mintRewardsForTransaction(
        address user,
        uint256 amount,
        uint256 transactionId
    ) external onlyOwner whenNotPaused {
        require(user != address(0), "Invalid user address");
        require(amount > 0, "Amount must be greater than 0");

        _mint(user, amount);
        totalTokensMinted += amount;

        // Actualizar puntos de fidelización
        userLoyaltyPoints[user] += amount / 10; // 1 punto por cada 10 tokens
        userTransactionCount[user]++;

        // Actualizar nivel VIP
        updateVIPLevel(user);

        emit TokensMintedForTransaction(user, amount, transactionId);
        emit LoyaltyPointsEarned(
            user,
            amount / 10,
            userLoyaltyPoints[user]
        );
    }

    /**
     * @dev Registrar contribución de desarrollador y acuñar tokens
     * @param developer Dirección del desarrollador
     * @param amount Cantidad de tokens como recompensa
     * @param contributionType Tipo de contribución (e.g., "agent", "integration")
     */
    function recordDeveloperContribution(
        address developer,
        uint256 amount,
        string memory contributionType
    ) external onlyOwner {
        require(developer != address(0), "Invalid developer address");
        require(amount > 0, "Amount must be greater than 0");

        // Acuñar tokens de recompensa
        _mint(developer, amount);
        totalTokensMinted += amount;

        // Registrar contribución
        developerContributions[developer] += amount;

        emit DeveloperContributionRecorded(developer, amount, contributionType);
    }

    // ============================================
    // REVENUE SHARING - Distribución automática
    // ============================================

    /**
     * @dev Distribuir ingresos a holders y desarrolladores
     * @param totalRevenue Ingreso total a distribuir (en unidades base)
     * @notice Distribución: 70% holders, 30% desarrolladores
     */
    function distributeRevenue(uint256 totalRevenue)
        external
        onlyOwner
        whenNotPaused
    {
        require(totalRevenue > 0, "Revenue must be greater than 0");
        require(
            block.timestamp >= lastDistributionTime + DISTRIBUTION_INTERVAL,
            "Distribution interval not met"
        );

        uint256 holdersShare = (totalRevenue * 70) / 100; // 70%
        uint256 developersShare = (totalRevenue * 30) / 100; // 30%

        // Distribuir a holders proporcionalmente a su balance
        _distributeToHolders(holdersShare);

        // Distribuir a desarrolladores según sus contribuciones
        _distributeToContributors(developersShare);

        totalDistributed += totalRevenue;
        lastDistributionTime = block.timestamp;

        emit RevenueDistributed(totalRevenue, holdersShare, developersShare);
    }

    /**
     * @dev Distribuir ganancias a holders (staking rewards)
     * @param amount Cantidad a distribuir
     */
    function _distributeToHolders(uint256 amount) internal {
        // Implementación simplificada: acuñar tokens adicionales
        // En producción, usar mecanismo de staking más sofisticado
        uint256 tokensToMint = amount; // 1:1 mapping para este ejemplo
        _mint(address(this), tokensToMint);
    }

    /**
     * @dev Distribuir ganancias a desarrolladores
     * @param amount Cantidad a distribuir
     */
    function _distributeToContributors(uint256 amount) internal {
        // Implementación: transferir proporcional a contribuciones
        // En producción, iterar sobre todos los desarrolladores
        uint256 tokensToMint = amount;
        _mint(address(this), tokensToMint);
    }

    // ============================================
    // VIP LEVEL MANAGEMENT
    // ============================================

    /**
     * @dev Actualizar nivel VIP basado en transacciones
     * @param user Dirección del usuario
     */
    function updateVIPLevel(address user) public {
        uint8 newLevel = calculateVIPLevel(userTransactionCount[user]);
        uint8 oldLevel = userVIPLevel[user];

        if (newLevel != oldLevel) {
            userVIPLevel[user] = newLevel;
            emit VIPLevelChanged(user, oldLevel, newLevel);
        }
    }

    /**
     * @dev Calcular nivel VIP según número de transacciones
     * @param transactionCount Número de transacciones
     * @return Nivel VIP (0-4)
     */
    function calculateVIPLevel(uint256 transactionCount)
        public
        pure
        returns (uint8)
    {
        if (transactionCount >= 150) return 4; // Platinum
        if (transactionCount >= 51) return 3; // Gold
        if (transactionCount >= 11) return 2; // Silver
        if (transactionCount >= 1) return 1; // Bronze
        return 0; // Default
    }

    /**
     * @dev Obtener descuento de tarifa según nivel VIP
     * @param vipLevel Nivel VIP del usuario
     * @return Descuento en porcentaje (e.g., 5 = 5%)
     */
    function getFeeDiscount(uint8 vipLevel)
        public
        pure
        returns (uint8)
    {
        if (vipLevel == 4) return 8; // Platinum: 8% discount
        if (vipLevel == 3) return 6; // Gold: 6% discount
        if (vipLevel == 2) return 4; // Silver: 4% discount
        if (vipLevel == 1) return 2; // Bronze: 2% discount
        return 0; // No discount
    }

    // ============================================
    // UTILITY FUNCTIONS
    // ============================================

    /**
     * @dev Obtener información del usuario
     * @param user Dirección del usuario
     */
    function getUserInfo(address user)
        external
        view
        returns (
            uint8 vipLevel,
            uint256 loyaltyPoints,
            uint256 transactionCount,
            uint8 feeDiscount
        )
    {
        vipLevel = userVIPLevel[user];
        loyaltyPoints = userLoyaltyPoints[user];
        transactionCount = userTransactionCount[user];
        feeDiscount = getFeeDiscount(vipLevel);
    }

    /**
     * @dev Canjear puntos de fidelización por tokens
     * @param points Cantidad de puntos a canjear
     */
    function redeemLoyaltyPoints(uint256 points)
        external
        whenNotPaused
    {
        require(
            userLoyaltyPoints[msg.sender] >= points,
            "Insufficient loyalty points"
        );

        userLoyaltyPoints[msg.sender] -= points;

        // 1 punto = 0.01 tokens (100 puntos = 1 token)
        uint256 tokensToTransfer = (points * 10 ** 16); // 0.01 * 10^18
        _transfer(address(this), msg.sender, tokensToTransfer);
    }

    /**
     * @dev Pausar/Reanudar el contrato (solo owner)
     */
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Actualizar porcentaje de distribución
     */
    function setDistributionFeePercentage(uint256 newPercentage)
        external
        onlyOwner
    {
        require(newPercentage <= 500, "Percentage too high"); // Max 5%
        distributionFeePercentage = newPercentage;
    }

    /**
     * @dev Establecer dirección del contrato de pagos
     */
    function setPaymentsContract(address _paymentsContract)
        external
        onlyOwner
    {
        require(_paymentsContract != address(0), "Invalid address");
        paymentsContract = _paymentsContract;
    }
}
