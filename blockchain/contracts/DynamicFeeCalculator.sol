// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./MoviYangToken.sol";

/**
 * @title DynamicFeeCalculator
 * @dev Calcula comisiones dinámicas basadas en valor entregado (2%-10%)
 */
contract DynamicFeeCalculator is Ownable, Pausable {
    // ============================================
    // STATE VARIABLES
    // ============================================

    MoviYangToken public moviYangToken;

    /// @dev Valor base por hora ahorrada (en cents)
    uint256 public hourlyValueInCents = 1000; // $10

    /// @dev Comisión mínima y máxima
    uint256 public constant MIN_FEE = 2; // 2%
    uint256 public constant MAX_FEE = 10; // 10%

    // ============================================
    // EVENTS
    // ============================================

    event FeeCalculated(
        address indexed user,
        uint256 productPrice,
        uint256 valueSaved,
        uint256 calculatedFee
    );

    // ============================================
    // CONSTRUCTOR
    // ============================================

    constructor(address _moviYangTokenAddress) {
        require(
            _moviYangTokenAddress != address(0),
            "Invalid token address"
        );
        moviYangToken = MoviYangToken(_moviYangTokenAddress);
    }

    // ============================================
    // FEE CALCULATION
    // ============================================

    /**
     * @dev Calcular tarifa dinámica basada en valor entregado
     * @param productPrice Precio del producto (en USD, 18 decimales)
     * @param timeSavedHours Horas ahorradas vs compra directa
     * @param priceSaving Dinero ahorrado por agregación (en USD, 18 decimales)
     * @param userAddress Dirección del usuario (para aplicar descuento VIP)
     * @return calculatedFee Tarifa en porcentaje (2-10%)
     */
    function calculateDynamicFee(
        uint256 productPrice,
        uint256 timeSavedHours,
        uint256 priceSaving,
        address userAddress
    ) external returns (uint256) {
        require(productPrice > 0, "Product price must be greater than 0");

        // Calcular valor total entregado
        uint256 timeValue = timeSavedHours * hourlyValueInCents * 10 ** 16; // Convert to 18 decimals
        uint256 totalValueDelivered = priceSaving + timeValue;

        // Calcular ratio de valor
        uint256 valueRatio = (totalValueDelivered * 100) / productPrice; // En %

        // Determinar tarifa base
        uint256 baseFee;
        if (valueRatio > 15) {
            baseFee = 10; // 10%
        } else if (valueRatio > 10) {
            baseFee = 8; // 8%
        } else if (valueRatio > 5) {
            baseFee = 5; // 5%
        } else {
            baseFee = 2; // 2%
        }

        // Aplicar descuento VIP
        uint8 vipLevel = moviYangToken.userVIPLevel(userAddress);
        uint8 vipDiscount = moviYangToken.getFeeDiscount(vipLevel);
        uint256 finalFee = baseFee - vipDiscount;

        // Asegurar que no caiga por debajo del mínimo
        if (finalFee < MIN_FEE) finalFee = MIN_FEE;

        emit FeeCalculated(
            userAddress,
            productPrice,
            totalValueDelivered,
            finalFee
        );

        return finalFee;
    }

    /**
     * @dev Calcular monto de comisión en USD
     * @param productPrice Precio del producto
     * @param feePercentage Porcentaje de comisión
     * @return Monto de la comisión
     */
    function calculateFeeAmount(
        uint256 productPrice,
        uint256 feePercentage
    ) external pure returns (uint256) {
        require(productPrice > 0, "Product price must be greater than 0");
        require(
            feePercentage >= MIN_FEE && feePercentage <= MAX_FEE,
            "Invalid fee percentage"
        );

        return (productPrice * feePercentage) / 100;
    }

    // ============================================
    // ADMIN FUNCTIONS
    // ============================================

    /**
     * @dev Actualizar valor hourly
     */
    function setHourlyValueInCents(uint256 newValue) external onlyOwner {
        require(newValue > 0, "Value must be greater than 0");
        hourlyValueInCents = newValue;
    }

    /**
     * @dev Pausar/Reanudar cálculos
     */
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
