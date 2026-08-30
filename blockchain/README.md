# Smart Contracts de MoviYa V2.0

## 📋 Contratos Inteligentes

### 1. MoviYangToken (ERC-20)
**Funcionalidad Principal**: Token de fidelización y recompensas

- Acuña tokens automáticamente después de cada transacción
- Rastrea puntos de lealtad de usuarios
- Gestiona niveles VIP (Bronze → Platinum)
- Distribuye ingresos automáticamente entre holders y desarrolladores
- Recompensa contribuciones de desarrolladores open-source

**Características**:
- Token inicial: 1,000,000 MYT
- Revenue Sharing automático: 70% holders, 30% desarrolladores
- Descuentos VIP: 2%-8% reducción de comisión según nivel

### 2. DynamicFeeCalculator
**Funcionalidad Principal**: Calcula comisiones dinámicas (2%-10%)

- Tarifa basada en valor entregado (precio ahorrado + tiempo)
- Aplicación automática de descuentos VIP
- Integración con MoviYangToken para nivel de usuario

**Fórmula**:
```
valueDelivered = priceSaving + (timeSavedHours × $10)
valueRatio = (valueDelivered / productPrice) × 100

if valueRatio > 15%   → 10%
if valueRatio > 10%   → 8%
if valueRatio > 5%    → 5%
else                  → 2%

finalFee = baseFee - vipDiscount
```

## 🚀 Despliegue

### Requisitos
```bash
cd blockchain
npm install
```

### Compilar Contratos
```bash
npm run compile
```

### Ejecutar Tests
```bash
npm run test
```

### Desplegar en BSC Testnet
```bash
# Configurar .env
echo "PRIVATE_KEY=tu_clave_privada" >> .env
echo "BSC_TESTNET_RPC=https://data-seed-prebsc-1-s1.binance.org:8545" >> .env

# Desplegar
npm run deploy:bsc-testnet
```

### Desplegar en BSC Mainnet
```bash
npm run deploy:bsc-mainnet
```

## 📊 Eventos Importantes

### MoviYangToken
- `TokensMintedForTransaction`: Se acuñan tokens por transacción
- `RevenueDistributed`: Se distribuyen ingresos
- `LoyaltyPointsEarned`: Usuario gana puntos de lealtad
- `VIPLevelChanged`: Usuario sube de nivel VIP
- `DeveloperContributionRecorded`: Contribución de desarrollador registrada

## 🔐 Seguridad

- Contratos heredan de OpenZeppelin (auditados)
- Funciones críticas con `onlyOwner`
- Pausable para emergencias
- Rate limiting implícito en distribuciones (1 distribución por día)

## 📝 Direcciones de Contrato

Una vez desplegados, las direcciones se guardarán en `.env.local`:
```
NEXT_PUBLIC_MOVIYANG_TOKEN_ADDRESS=0x...
NEXT_PUBLIC_FEE_CALCULATOR_ADDRESS=0x...
```

## 🤝 Verificación en Bscscan

Para verificar contratos en BSCscan:
```bash
npm run verify -- --network bsc-mainnet 0xTuDireccion "ConstructorArg1" "ConstructorArg2"
```
