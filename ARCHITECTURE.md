# Especificación Técnica - MoviYa V2.0

## 1. Visión Global del Sistema

MoviYa es una plataforma de **orquestación inteligente** que integra tres pilares:

1. **Agregación de E-Commerce**: Metabúsqueda en Amazon, AliExpress, Temu
2. **Optimización Logística**: Comparación de rutas en Uber, DiDi, Rappi
3. **Monetización Inteligente**: Comisiones dinámicas + Tokenomics + Revenue Sharing

---

## 2. Arquitectura de Enjambre de IA (AI Swarm Architecture)

### Componentes Principales

#### 2.1 Master Node Router (Orquestador Central)
- **Tecnología**: Python FastAPI + LLM (OpenAI GPT-4)
- **Responsabilidad**: Recibir solicitudes, clasificar intención, delegar a agentes
- **Puerto**: 8000
- **Flujo**:
  ```
  Usuario: "Necesito un iPhone 15 Pro en Medellín hoy"
       ↓
  [LLM clasifica: E-commerce + urgencia alta]
       ↓
  [Delega a: Agente E-commerce + Agente Logístico]
       ↓
  [Agentes buscan en paralelo, retornan resultados]
       ↓
  [Master Node calcula mejor oferta]
       ↓
  Usuario recibe respuesta optimizada
  ```

#### 2.2 Agente E-Commerce (Go Microservicio)
- **Tecnología**: Go + Fiber + Colly (scraping)
- **Responsabilidad**: Buscar y agregar precios de múltiples fuentes
- **Puerto**: 8001
- **Algoritmo**:
  1. Recibir query de búsqueda
  2. Hacer requests paralelos a APIs de Amazon, AliExpress, Temu
  3. Normalizar datos (precio, disponibilidad, tiempo de envío)
  4. Retornar ranking por precio + velocidad

#### 2.3 Agente Logístico (Go Microservicio)
- **Tecnología**: Go + Fiber + Google Maps API
- **Responsabilidad**: Comparar rutas de transporte
- **Puerto**: 8002
- **Algoritmo**:
  1. Recibir coordenadas origen/destino
  2. Hacer requests a APIs de Uber, DiDi, Rappi
  3. Calcular ETA, precio, rating del conductor
  4. Retornar opción óptima

#### 2.4 Agente Financiero
- **Tecnología**: Python + FastAPI
- **Responsabilidad**: Cálculos de tarifa dinámica, procesamiento de pagos
- **Funciones**:
  - `calculate_dynamic_fee()`: Determina comisión (2%-10%)
  - `process_payment()`: Interfaz con Binance Pay
  - `distribute_revenue()`: Distribuye ingresos automáticamente

#### 2.5 Agente de Soporte (IA Conversacional)
- **Tecnología**: Python + LangChain + OpenAI
- **Responsabilidad**: Soporte automatizado 24/7
- **Capacidades**:
  - Responder preguntas sobre envíos
  - Procesar reembolsos automáticos
  - Gestionar devoluciones

---

## 3. Motor de Monetización Dinámica

### 3.1 Algoritmo de Tarifa Dinámmica

```python
def calculate_dynamic_fee(product_price, value_generated, user_vip_level):
    """
    value_generated = (price_saving + time_saved * HOURLY_VALUE)
    
    Si value_generated / product_price > 15% → tarifa 10%
    Si value_generated / product_price > 10% → tarifa 8%
    Si value_generated / product_price > 5%  → tarifa 5%
    Sino                                     → tarifa 2%
    
    Descuento VIP: -0.5% por cada nivel VIP
    """
    pass
```

### 3.2 Estructura de Ingresos

| Flujo | Porcentaje | Destino |
|-------|-----------|--------|
| Comisión de usuario | 100% | Pool de distribución |
| → Operación | 80% | Infraestructura, IA, DB |
| → Revenue Sharing | 15% | Desarrolladores (Smart Contract) |
| → Reserva | 5% | Fondo de estabilidad |

---

## 4. Base de Datos y Modelos

### 4.1 Esquema Principal (PostgreSQL)

```sql
-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    vip_level INT DEFAULT 0,
    wallet_address VARCHAR(42),
    created_at TIMESTAMP
);

-- Transactions
CREATE TABLE transactions (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users,
    product_name VARCHAR(255),
    source VARCHAR(50),
    original_price DECIMAL(10,2),
    final_price DECIMAL(10,2),
    moviyang_fee DECIMAL(10,2),
    payment_status VARCHAR(50),
    created_at TIMESTAMP
);

-- Rewards
CREATE TABLE rewards (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users,
    points INT,
    transaction_id UUID REFERENCES transactions,
    created_at TIMESTAMP
);

-- Smart Contract Events
CREATE TABLE blockchain_events (
    id UUID PRIMARY KEY,
    transaction_hash VARCHAR(66),
    event_type VARCHAR(50),
    user_address VARCHAR(42),
    amount DECIMAL(18,8),
    block_number INT,
    created_at TIMESTAMP
);
```

---

## 5. Web3 y Smart Contracts (Solidity)

### 5.1 Contrato Principal: MoviYangToken

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MoviYangToken is ERC20, Ownable {
    // Evento: Recompensa otorgada
    event RewardDistributed(address indexed user, uint256 amount);
    
    // Función: Emitir tokens por transacción completada
    function mintRewards(address user, uint256 amount) external onlyOrchestrator {
        _mint(user, amount);
        emit RewardDistributed(user, amount);
    }
    
    // Función: Revenue Sharing automático
    function distributeRevenue(uint256 totalRevenue) external onlyAdmin {
        // Distribuir al 15% de los holders según su porcentaje
    }
}
```

### 5.2 Despliegue

- **Red**: BNB Chain (BSC)
- **Gas Optimizado**: Sí (Solidity 0.8.0+)
- **Verificación**: Etherscan BSC

---

## 6. Frontend (Next.js + Glassmorphism)

### 6.1 Arquitectura de UI

```
frontend/
├── app/
│   ├── page.tsx              # Landing page
│   ├── search/               # Búsqueda agregada
│   ├── checkout/             # Carrito y pago
│   ├── dashboard/            # Panel de usuario
│   └── admin/                # Panel administrativo
├── components/
│   ├── SearchBar.tsx         # Búsqueda principal
│   ├── ProductCard.tsx       # Card de producto
│   ├── PriceComparison.tsx  # Comparativa de precios
│   └── ThemeToggle.tsx       # Dark/Light mode
├── styles/
│   └── globals.css           # Estilos Glassmorphism
└── lib/
    ├── api.ts                # Cliente HTTP
    └── web3.ts               # Interacción Blockchain
```

### 6.2 Tema Visual (Glassmorphism)

```css
/* Dark mode por defecto */
:root {
  --bg-primary: #0a0a0a;      /* Ónix */
  --bg-secondary: #1a1a1a;
  --accent-primary: #d4af37;  /* Oro digital */
  --accent-secondary: #ffd700; /* Ámbar */
}

/* Glassmorphism effect */
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
}
```

---

## 7. CI/CD y Deployment

### 7.1 GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy MoviYa

on:
  push:
    branches: [main, v2-*]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker images
        run: docker-compose build
      - name: Push to Registry
        run: docker-compose push
      - name: Deploy to K8s
        run: kubectl apply -f k8s/
```

### 7.2 Entornos

- **Dev**: `localhost:3000`
- **Staging**: `staging.moviyang.com`
- **Prod**: `app.moviyang.com`

---

## 8. Seguridad

### 8.1 Autenticación

- JWT + Refresh Tokens
- WebAuthn para autenticación sin contraseña
- 2FA obligatorio para transacciones >$100
- Biometría (FaceID, Touch ID, Windows Hello)

### 8.2 Protección de Datos

- Encriptación E2E para datos sensibles
- Rate limiting: 100 req/min por usuario
- CORS configurado restrictivamente
- Validación de input en todas las APIs

---

## 9. Escalabilidad

### 9.1 Caching

- Redis para sesiones de usuario
- Cache de precios (TTL: 5 min)
- CDN para assets estáticos

### 9.2 Base de Datos

- PostgreSQL con replicación master-slave
- Índices en campos frecuentes (user_id, created_at)
- Particionamiento de tabla `transactions` por fecha

### 9.3 Microservicios

- Cada servicio independiente y escalable
- Load balancer (Nginx) distribuye tráfico
- Auto-scaling en K8s según CPU/Memoria

---

## 10. Roadmap

### Fase 1 (Actual)
- ✅ Arquitectura base
- ✅ Agentes E-commerce y Logístico
- ✅ Motor de tarifa dinámica
- ✅ Frontend con Glassmorphism

### Fase 2
- Smart Contracts de Revenue Sharing
- Integraciones con Binance Pay
- Gamificación completa

### Fase 3
- Aplicaciones móviles (iOS/Android)
- Agentes adicionales (Insurance, Customs)
- Marketplace interno para desarrolladores

---

## 11. Referencias y Recursos

- [API Documentation](./docs/API.md)
- [Local Development Guide](./docs/DEVELOPMENT.md)
- [Blockchain Contract ABI](./blockchain/contracts/)
- [Contributing Guidelines](./CONTRIBUTING.md)
