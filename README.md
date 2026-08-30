# MoviYa V2.0

## 🌍 Plataforma Global de E-Commerce, Logística e Inteligencia Artificial Orquestada

### Visión General

**MoviYa** es un ecosistema integral que integra e-commerce global (Amazon, AliExpress, Temu) con servicios de logística y transporte (Uber, DiDi, Rappi), orquestado por un **enjambre de Inteligencias Artificiales autónomas** y monetizado mediante:

- ✅ **Comisiones dinámicas** (2%-10%) basadas en valor ahorrado
- ✅ **Tokens de fidelización** en blockchain (Web3)
- ✅ **Revenue Sharing** automático para desarrolladores open-source
- ✅ **Soporte IA humanizado** con resolución instantánea de fricciones
- ✅ **Gamificación y Niveles VIP** con incentivos tangibles

---

## 🏗️ Arquitectura del Sistema

### Malla de Inteligencias Artificiales (AI Swarm)

```
┌─────────────────────────────────────────┐
│   Orquestador Central (Master Node)     │
│   • Procesa intenciones de usuario      │
│   • Delega tareas a agentes especializados
│   • Coordina respuestas en tiempo real  │
└────────┬────────────────────────────────┘
         │
    ┌────┴────────────────────┬──────────┐
    │                         │          │
    ▼                         ▼          ▼
┌──────────────┐     ┌──────────────┐  ┌──────────────┐
│ Agente E-Com │     │ Agente Log.  │  │ Agente Fin.  │
│ (Scraping)   │     │ (Rutas)      │  │ (Pagos)      │
└──────────────┘     └──────────────┘  └──────────────┘
```

### Stack Tecnológico

| Componente | Tecnología | Puerto |
|-----------|-----------|-------|
| **Frontend** | Next.js 14 + Tailwind + Glassmorphism | 3000 |
| **Orquestador IA** | Python 3.11 + FastAPI + LLM | 8000 |
| **E-commerce** | Go 1.21 + Fiber | 8001 |
| **Logística** | Go 1.21 + Fiber | 8002 |
| **Base de Datos** | PostgreSQL 15 | 5432 |
| **Cache/Queue** | Redis 7 | 6379 |
| **Blockchain** | Solidity (BNB Chain/Ethereum) | Web3 |

---

## 🚀 Quick Start

### Requisitos Previos

- Docker & Docker Compose (>= 20.10)
- Git
- Node.js 18+ (para desarrollo local)
- Python 3.11+
- Go 1.21+

### Instalación y Ejecución

```bash
# 1. Clonar repositorio
git clone https://github.com/moviYa23/MoviYa.git
cd MoviYa

# 2. Copiar variables de entorno
cp .env.example .env
# Editar .env con tus claves API

# 3. Construir e iniciar contenedores
docker-compose up -d

# 4. Verificar servicios
docker-compose ps

# 5. Acceder a la plataforma
# Frontend: http://localhost:3000
# API: http://localhost:8000/docs
```

### Estructura de Carpetas

```
MoviYa/
├── frontend/                  # Next.js App (SSR, Dark Mode, Glassmorphism)
│   ├── app/
│   ├── components/
│   ├── styles/
│   └── public/
│
├── orchestrator/              # Master Node Router (Python/FastAPI)
│   ├── main.py
│   ├── agents/               # Agentes especializados
│   ├── models/               # Modelos de datos
│   ├── services/             # Lógica de negocio
│   └── requirements.txt
│
├── services/                 # Microservicios en Go
│   ├── ecommerce/            # Motor E-commerce (Puerto 8001)
│   │   ├── main.go
│   │   ├── handlers/
│   │   └── Dockerfile
│   │
│   └── logistics/            # Motor Logístico (Puerto 8002)
│       ├── main.go
│       ├── handlers/
│       └── Dockerfile
│
├── blockchain/               # Smart Contracts & Web3
│   ├── contracts/
│   │   └── MoviYangToken.sol
│   ├── scripts/
│   ├── test/
│   └── hardhat.config.js
│
├── database/
│   └── migrations/           # SQL schemas
│
├── scripts/
│   ├── init.sql             # Inicialización DB
│   └── deploy.sh            # Script de despliegue
│
└── docker-compose.yml        # Orquestación de servicios
```

---

## 💰 Sistema de Monetización Dinámica

### Algoritmo de Tarifa Dinámmica (2%-10%)

```python
def calculate_dynamic_fee(product_price, time_saved, price_saving, user_vip_level):
    """
    Calcula la tarifa de servicio basada en el valor entregado.
    
    Inputs:
    - product_price: Precio del producto (USD)
    - time_saved: Horas ahorradas vs compra directa
    - price_saving: Dinero ahorrado por agregación
    - user_vip_level: Nivel VIP del usuario (0-10)
    
    Output:
    - fee_percentage: Tarifa final (2%-10%)
    """
    # Cálculo de valor agregado
    total_value_saved = price_saving + (time_saved * HOURLY_VALUE)
    value_ratio = total_value_saved / product_price
    
    # Tarifa base según ratio de valor
    if value_ratio > 0.15:      # >15% de ahorro
        base_fee = 10.0
    elif value_ratio > 0.10:    # 10-15%
        base_fee = 8.0
    elif value_ratio > 0.05:    # 5-10%
        base_fee = 5.0
    else:                       # <5%
        base_fee = 2.0
    
    # Descuento por nivel VIP (máximo 5%)
    vip_discount = (user_vip_level / 10) * 5
    final_fee = max(2.0, base_fee - vip_discount)
    
    return final_fee
```

### Distribución de Ingresos

- **80%** → Plataforma MoviYa (infraestructura, IA, soporte)
- **15%** → Revenue Sharing a Desarrolladores (Smart Contract automático)
- **5%** → Fondo de Reserva (estabilidad y crecimiento)

---

## 🔗 Web3 & Blockchain (Tokenomics)

### Smart Contract: MoviYangToken (ERC-20 + Revenue Sharing)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MoviYangToken is ERC20 {
    // Por cada transacción, 1% es distribuido automáticamente
    // a los holders según su % de participación
    
    function distributeRewards(uint256 amount) external onlyAdmin {
        uint256 rewardPerToken = amount / totalSupply();
        // Lógica de distribución...
    }
}
```

### Flujo de Tokenización

```
Usuario realiza compra
       ↓
[Transacción confirmada en MoviYa]
       ↓
[Smart Contract emite tokens MYT]
       ↓
[Tokens depositados en billetera del usuario]
       ↓
[Redimibles en futuras compras o conversión a USDT]
```

---

## 🤖 Agentes de IA Autónomos

### 1. Master Node Router (Orquestador Central)
**Responsabilidad:** Procesar intenciones de usuario y delegar tareas

```python
# orchestrator/agents/master_router.py
class MasterNodeRouter:
    def process_user_intent(self, prompt: str):
        # 1. Usar LLM para clasificar intención
        intent = self.classify_intent(prompt)
        # 2. Delegar a agente especializado
        result = await self.delegate_to_specialist(intent)
        return result
```

### 2. Agente E-Commerce (Scraping)
**Responsabilidad:** Buscar precios en Amazon, AliExpress, Temu

### 3. Agente Logístico (Routeo)
**Responsabilidad:** Comparar rutas y precios de Uber, DiDi, Rappi

### 4. Agente Financiero
**Responsabilidad:** Cálculos de tarifa, procesamiento de pagos

### 5. Agente de Soporte (Support IA)
**Responsabilidad:** Resolución automática de conflictos, reembolsos

---

## 🔐 Seguridad y Autenticación

- ✅ **WebAuthn + Biometría** (FaceID, Touch ID, Windows Hello)
- ✅ **JWT + Refresh Tokens**
- ✅ **2FA por SMS/Email**
- ✅ **Rate Limiting** en todas las APIs
- ✅ **Encriptación E2E** para datos sensibles

---

## 📊 API Endpoints Principales

### Orquestador (Puerto 8000)

```bash
# Iniciar búsqueda agregada
POST /api/search
Body: {
  "query": "iPhone 15 Pro",
  "destination": "Medellín, Colombia",
  "urgency": "today"
}

# Obtener historial de transacciones
GET /api/transactions

# Procesar pago
POST /api/checkout
Body: {
  "items": [...],
  "payment_method": "usdt"
}
```

### E-Commerce (Puerto 8001)

```bash
# Buscar producto
GET /api/products/search?q=laptop&limit=10

# Obtener detalles de proveedor
GET /api/products/:id/providers
```

### Logística (Puerto 8002)

```bash
# Cotizar envío
POST /api/shipping/quote
Body: {
  "origin": "lat,lng",
  "destination": "lat,lng",
  "weight_kg": 2.5
}

# Crear orden de transporte
POST /api/shipping/order
```

---

## 🎮 Gamificación y Programa de Fidelización

### Niveles VIP

| Nivel | Requisitos | Tarifa Base | Beneficios |
|-------|-----------|------------|------------|
| **Bronze** | 0-10 compras | 10% | Acceso básico |
| **Silver** | 11-50 compras | 6% | Soporte prioritario |
| **Gold** | 51-150 compras | 4% | Ofertas exclusivas |
| **Platinum** | 150+ compras | 2% | Eventos VIP, Cashback |

### Puntos y Recompensas

- 1 punto por cada dólar gastado
- Puntos canjeables por:
  - Descuentos en futuras compras
  - Productos gratis del catálogo
  - Conversión a USDT (0.01 USD por punto)

---

## 🚢 Deployment

### Desarrollo Local
```bash
docker-compose -f docker-compose.yml up
```

### Producción (AWS/GCP/Azure)
```bash
# Requisitos: K8s, ArgoCD, Prometheus
# Scripts disponibles en ./scripts/deploy.sh
bash scripts/deploy.sh --env production
```

---

## 🤝 Contribuciones Open-Source

MoviYa es un proyecto de código abierto. Cualquier ingeniero del mundo puede:

1. **Clonar el repositorio**
2. **Crear mejoras** (nuevos agentes, integraciones)
3. **Hacer Pull Request**
4. **Recibir Revenue Sharing automático** mediante Smart Contracts

### Cómo Contribuir

```bash
# 1. Fork el repo
git clone https://github.com/YOUR_USERNAME/MoviYa.git
cd MoviYa

# 2. Crear rama de feature
git checkout -b feature/new-agent

# 3. Hacer cambios y commitear
git add .
git commit -m "feat: Nuevo agente de IA para X"

# 4. Push y crear PR
git push origin feature/new-agent
```

Una vez mergeado, tus contribuciones serán registradas en blockchain y recibirás recompensas automáticamente.

---

## 📚 Documentación Adicional

- [Guía de Arquitectura](./docs/ARCHITECTURE.md)
- [API Reference](./docs/API.md)
- [Smart Contract Docs](./blockchain/README.md)
- [Guía de Despliegue](./docs/DEPLOYMENT.md)
- [Contribuciones y Revenue Sharing](./docs/REVENUE_SHARING.md)

---

## 📜 Licencia

Licencia: **Apache 2.0**

Uso comercial permitido, con atribución obligatoria.

---

## 📞 Soporte

- **Issues**: Abre un issue en GitHub
- **Comunidad**: Discord (próximamente)
- **Email**: dev@moviyang.com
- **Documentación**: https://docs.moviyang.com

---

**MoviYa V2.0 - Orquestación Global de Comercio, Logística e Inteligencia Artificial** 🚀
