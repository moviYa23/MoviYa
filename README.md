# 🚗 MoviYa V25.0 - Plataforma Inteligente de Transporte & E-Commerce

**Versión:** 25.0 (Producción)  
**Estado:** ✅ Operacional (CIS Benchmark & DevSecOps Certified)  
**Licencia:** MIT  
**Autor:** moviYa23 (César - Ingeniero de Sistemas)

---

## 📋 Descripción General

**MoviYa** es una **plataforma descentralizada de transporte de personas y artículos** con arquitectura híbrida:

- **PC Local:** 4GB RAM con microservicios orquestados en Docker
- **Edge Computing:** Nodo móvil Termux (Android) con sincronización PQC
- **Blockchain:** BNB Chain para tokenómica (MYA Token) y gobernanza DAO
- **Seguridad Avanzada:** Criptografía post-cuántica (Kyber-1024, Dilithium-5)
- **IA Distribuida:** SentiumX Swarm para decisiones autónomas

---

## 🎯 Centro de Control Maestro V25.0

### ¿Qué es?

Sistema central de gestión con **36 dimensiones de control** para:
- Despliegue & verificación de infraestructura
- Auditoría de seguridad (código, contenedores, red)
- Monitoreo de rendimiento en tiempo real
- Blockchain & Smart Contracts
- IA & Orquestación autónoma
- Diagnóstico avanzado & auto-reparación

### 🚀 Inicio Rápido

```bash
# 1. Clonar repositorio
git clone https://github.com/moviYa23/MoviYa.git
cd MoviYa

# 2. Ejecutar instalador automático
chmod +x moviya-quickstart-installer.sh
./moviya-quickstart-installer.sh

# 3. Iniciar Centro de Control
./moviya-cc.sh
# O ejecutar directamente:
./moviya-control-center-master-v25.sh
```

### 📊 Panel Principal (36 Opciones)

```
===================================================================
         MOVIYA V25.0 • CENTRO DE CONTROL MAESTRO (36 DIMENSIONES)
======================================================================
Ecosistema: Transporte • E-Commerce • PQC Security • Governance & AI Swarm

[INFRAESTRUCTURA & DESPLIEGUE]
 [1]  🚀 Deploy & Verificar Infraestructura Total
 [2]  🐋 Audit de Contenedores Docker
 [3]  🔐 Autenticación Criptográfica PQC LEGO

[AUDITORÍA & SEGURIDAD]
 [4]  🔍 Auditoría Estática de Código
 [5]  🛡️  Hardening de Sistema Ubuntu/WSL2
 [6]  📜 Cronjob de Seguridad de Sistema

[RENDIMIENTO & MONITOREO]
 [7]  ⚡ Benchmark de Latencias Redis
 [8]  📊 Monitoreo de Rendimiento en Tiempo Real
 [9]  📦 Sincronización y Respaldo de Archivos
[10]  🌐 Auditoría Completa de Red

[BLOCKCHAIN & SMART CONTRACTS]
[11]  🔑 Verificación de Hashes de Smart Contracts
[12]  🎯 Pruebas de Estrés 10K Usuarios Concurrentes
[13]  🔏 Verificador de Checksums de Firmware PQC
[14]  🛑 Simulación de Intrusión y Respuesta Defensiva

[SECRETOS & ENTORNO]
[15]  🔑 Auditoría de Secretos y Entorno (.env)
[16]  ⚙️  Auditar Configuración de Hardhat
[17]  🚦 Inspeccionar Tráfico de Red

[IA & ORQUESTACIÓN]
[18]  🤖 Iniciar Orquestador SentiumX
[19]  🔌 Tunelizador Móvil Termux PQC

[FRONTEND & UI]
[20]  🖥️  Linter de Compilación Frontend React

[SESIONES & SEGURIDAD ACTIVA]
[21]  🔄 Monitor de Sesiones Activas
[22]  🧪 Pruebas de Integración PQC y Oráculos

[VULNERABILIDADES & PUERTOS]
[23]  🛡️ Escáner de Vulnerabilidades de Dependencias
[24]  🔌 Auditor de Puertos Locales y Firewalls

[BASE DE DATOS & DATOS]
[25]  🐘 Migración de Base de Datos PostgreSQL
[26]  🚗 Inyectar 5,000 Viajes Históricos Simulados
[27]  📈 Analíticas Financieras y Comisiones del Enjambre

[BLOCKCHAIN & TOKENS]
[28]  💎 Desplegar MYA Utility Token (BNB Chain)
[29]  🔄 Sincronizar ABIs de Solidity con React Frontend

[CORPORACIÓN AUTÓNOMA]
[30]  🏛️ Inicializar Corporación Autónoma de IAs Éticas (SentiumX)
[31]  📱 Bot de Alertas Telegram (SentiumX Bridge)

[DIAGNÓSTICO & RECUPERACIÓN]
[32]  🏥 Diagnóstico Avanzado + Auto-Reparación
[33]  📊 Monitor GitHub Actions en Tiempo Real

[NODOS AUTÓNOMOS]
[34]  🌐 Gestor MAYA-X Core V1.0 (Puerto :8787)

[CRIPTOGRAFÍA POST-CUÁNTICA]
[35]  🔐 Auditoría Túnel Kyber-1024
[36]  ⚡ Simulador de Ataque Cuántico PQC

 [0]  ❌ Salir
----------------------------------------------------------------------
```

---

## 📚 Documentación Completa

### Archivos Clave

| Archivo | Descripción |
|---------|-------------|
| **`moviya-control-center-master-v25.sh`** | Script principal (36 opciones interactivas) |
| **`moviya-quickstart-installer.sh`** | Instalador automático con detección de SO |
| **`moviya-control-center-master-v25-guide.md`** | Guía completa de uso y configuración |
| **`docker-compose-celeron-v25.yml`** | Orquestación de servicios (PC de 4GB RAM) |
| **`.env.example`** | Plantilla de variables de entorno |

### Estructura del Proyecto

```
MoviYa/
├── moviya-control-center-master-v25.sh       # Centro de control (36 opciones)
├── moviya-quickstart-installer.sh            # Instalador automático
├── moviya-control-center-master-v25-guide.md # Documentación completa
├── docker-compose-celeron-v25.yml            # Stack Docker optimizado
├── .env                                       # Variables de entorno (secreto)
├── .env.example                               # Plantilla .env
│
├── backend/                                   # Microservicios backend
│   ├── master-router.py                       # Orquestador central
│   ├── logistics_oracle.py                    # Oráculo de logística
│   ├── red-maya-core.py                       # Red MAYA descentralizada
│   ├── pqc-auth-lego.py                       # Autenticación PQC
│   └── ... (otros servicios)
│
├── frontend/                                  # React + TypeScript
│   ├── EliteDashboard-v5.tsx                  # Dashboard principal
│   ├── MoviYaClientApp-v2.tsx                 # App de cliente
│   └── ... (componentes)
│
├── contracts/                                 # Smart Contracts Solidity
│   ├── DeveloperIncentives-v1.sol             # Programa de incentivos
│   ├── RevenueSharing.sol                     # Distribución de ingresos
│   ├── SwarmRewardsDistribution.sol           # Recompensas enjambre
│   └── ... (otros contratos)
│
├── scripts/                                   # Scripts de deployment & audit
│   ├── deploy-and-verify-v4.sh                # Deploy de infraestructura
│   ├── static-code-audit-v2.sh                # Auditoría de código
│   ├── docker-compose-linter.sh               # Linter de Docker
│   ├── redis-cluster-benchmark.sh             # Benchmark Redis
│   ├── ubuntu-hardening.sh                    # Hardening de SO
│   └── ... (30+ scripts más)
│
├── logs/                                      # Directorio de logs
└── backups/                                   # Backups automáticos
```

---

## 🔧 Requisitos Previos

### Mínimos
- **OS:** Linux/WSL2/macOS/Termux
- **RAM:** 4GB (recomendado 8GB)
- **Disco:** 5GB libres
- **Internet:** Conexión activa (para blockchain)

### Obligatorios (Auto-Instalables)
```bash
# El instalador configura automáticamente:
✅ Bash 5.0+
✅ Git
✅ Python 3.9+
✅ Node.js 18+
✅ Docker & Docker Compose
✅ PostgreSQL 13+
✅ Redis 6+
✅ OpenSSL 1.1+
```

---

## 📦 Instalación Paso a Paso

### 1. **Clonar Repositorio**
```bash
git clone https://github.com/moviYa23/MoviYa.git
cd MoviYa
```

### 2. **Ejecutar Instalador (Recomendado)**
```bash
chmod +x moviya-quickstart-installer.sh
./moviya-quickstart-installer.sh
```

**El instalador:**
- ✅ Detecta tu SO (Linux/WSL2/macOS/Termux)
- ✅ Instala dependencias de sistema
- ✅ Configura entorno virtual Python
- ✅ Instala dependencias Node.js
- ✅ Crea archivo `.env` seguro
- ✅ Verifica puertos disponibles
- ✅ Inicializa servicios Docker (opcional)
- ✅ Crea acceso rápido global

### 3. **Configurar Variables de Entorno**
```bash
# El instalador crea .env automáticamente
# Editarlo con valores reales:
nano .env
```

**Variables críticas:**
```env
BLOCKCHAIN_RPC=https://bsc-dataseed.binance.org:443
BLOCKCHAIN_PRIVATE_KEY=tu_clave_privada
POSTGRES_PASSWORD=contraseña_segura
REDIS_PASSWORD=contraseña_redis
TELEGRAM_BOT_TOKEN=tu_token_bot
```

### 4. **Iniciar Centro de Control**
```bash
# Opción A: Usando acceso rápido
./moviya-cc.sh

# Opción B: Script directo
./moviya-control-center-master-v25.sh

# Opción C: Enlace global (si se creó)
moviya-cc
```

---

## 🎮 Uso del Centro de Control

### Seleccionar Opción
```bash
Selecciona una opción [0-36]: 1
```

### Ejemplos de Uso

#### Opción [1] - Deploy & Verificar Infraestructura
```bash
Selecciona una opción [0-36]: 1
# Inicia automáticamente todos los servicios y valida:
# ✅ Docker daemon
# ✅ PostgreSQL conectada
# ✅ Redis disponible
# ✅ Blockchain RPC respondiendo
# ✅ Frontend compilado
```

#### Opción [7] - Benchmark Redis
```bash
Selecciona una opción [0-36]: 7
# Ejecuta pruebas de rendimiento:
# GET: 0.45ms (avg), 150,000 ops/sec
# SET: 0.52ms (avg), 145,000 ops/sec
# P95 Latency: 2.1ms
# ✅ Cumple SLA
```

#### Opción [28] - Desplegar MYA Token
```bash
Selecciona una opción [0-36]: 28
# Despliegue automático en BNB Chain:
# ✅ Contrato compilado
# ✅ Verificado en blockchain
# ✅ Parámetros de tokenómica inicializados
```

#### Opción [32] - Diagnóstico Avanzado
```bash
Selecciona una opción [0-36]: 32
# Reporte completo cada 6 horas:
# 📊 Health checks de todos los servicios
# 🔍 Performance bottlenecks detectados
# 🛠️ Auto-reparación ejecutada
# 📧 Email de alerta enviado
```

---

## 🔐 Seguridad

### Criptografía Post-Cuántica (PQC)

MoviYa implementa algoritmos resistentes a computación cuántica:

| Componente | Algoritmo | Resistencia |
|-----------|-----------|------------|
| Encapsulación | **Kyber-1024** | 2^256 operaciones |
| Firma Digital | **Dilithium-5** | Hash-based |
| Función Hash | **SHA3-256** | Cuántica-segura |
| Sesiones | **LEGO** | LDAP Group Signatures |

### Hardening de Sistema

Opción [5] implementa CIS Benchmark v1.1.0:
- ✅ Kernel hardening (sysctl)
- ✅ SELinux/AppArmor policies
- ✅ SSH hardening (puerto personalizado, no-root)
- ✅ Firewall UFW
- ✅ Auditoría con auditd

### Monitoreo de Sesiones

Opción [21] detecta:
- ✅ Cambios de IP sospechosos
- ✅ User-Agent modifications
- ✅ Geolocalización anómala
- ✅ Session hijacking attempts
- ✅ Auto-invalidación de sesiones

---

## 📊 Arquitectura

### Componentes Principales

```
┌─────────────────────────────────────────────────────────────┐
│                    MOVIYA V25.0 ARCHITECTURE                 │
└─────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────┐
│   PC LOCAL       │         │  TERMUX (EDGE)   │
│   (4GB RAM)      │ ◄────►  │   (Android)      │
│                  │  PQC    │                  │
│ • Docker         │  Túnel  │ • SQLite cache   │
│ • PostgreSQL     │         │ • GPS streaming  │
│ • Redis          │         │ • Offline sync   │
│ • Node.js        │         │                  │
└──────────────────┘         └──────────────────┘
       ▲                              ▲
       │                              │
       ▼                              ▼
┌──────────────────┐         ┌──────────────────┐
│  BLOCKCHAIN      │         │   SENTIUMX DAO   │
│  BNB CHAIN       │         │  (AI Swarm)      │
│                  │         │                  │
│ • MYA Token      │         │ • Auto Decisions │
│ • Smart Contracts│         │ • Governance     │
│ • Oraculos       │         │ • Validadores    │
└──────────────────┘         └──────────────────┘
```

### Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| **Frontend** | React 18 + TypeScript + TailwindCSS |
| **Backend** | Python (FastAPI) + Go (logística) + Node.js |
| **Base Datos** | PostgreSQL + Redis + SQLite (edge) |
| **Blockchain** | Solidity + BNB Chain + Oraculos Chainlink |
| **IA** | Python (ML models) + SentiumX (orquestación) |
| **Seguridad** | PQC (Kyber, Dilithium) + TLS 1.3 + JWT |
| **Containerización** | Docker + Docker Compose |
| **CI/CD** | GitHub Actions + Automated Testing |

---

## 🧪 Testing & QA

### Pruebas Automatizadas

```bash
# [4] Auditoría Estática - Verifica:
# ✅ Vulnerabilidades de código
# ✅ Code coverage (target: 90%)
# ✅ Code style & linting

# [12] Stress Test 10K - Simula:
# ✅ 10,000 usuarios concurrentes
# ✅ 1.25M requests en 5 minutos
# ✅ 99.8% tasa de éxito esperada

# [22] Pruebas de Integración - Valida:
# ✅ Flujos end-to-end
# ✅ Integración PQC
# ✅ Oráculos blockchain
```

### Reporte de Cobertura

```bash
# Ver cobertura de tests
pytest --cov=. --cov-report=html
open htmlcov/index.html
```

---

## 🚀 Despliegue en Producción

### Pre-Despliegue Checklist

```bash
# 1. Ejecutar auditoría completa
./moviya-control-center-master-v25.sh
# Opción [4] - Auditoría Estática

# 2. Verificar seguridad
# Opción [15] - Auditoría de Secretos
# Opción [23] - Vulnerabilidades de Dependencias

# 3. Hardening del sistema
# Opción [5] - Hardening Ubuntu/WSL2

# 4. Backup de datos
# Opción [9] - Sincronización y Respaldo
```

### Deploy en BNB Chain

```bash
# Opción [28] - Desplegar MYA Token
./moviya-control-center-master-v25.sh
# Selecciona: 28

# Verifica en BlockScout
# https://bscscan.com/address/0x...
```

---

## 📈 Monitoreo & Métricas

### Dashboard en Tiempo Real

```bash
# Opción [8] - Monitoreo de Rendimiento
./moviya-control-center-master-v25.sh
# Selecciona: 8

# Muestra en vivo:
# • CPU (por core)
# • Memoria RAM
# • I/O Disk
# • Red (bytes in/out)
# • Procesos TOP
```

### Logs Centralizados

```bash
# Ver logs de Centro de Control
tail -f logs/moviya_control_center_*.log

# Buscar errores
grep ERROR logs/moviya_control_center_*.log

# Exportar reporte
cat logs/moviya_control_center_*.log > report.txt
```

---

## 🤝 Contribuir

### Cómo Colaborar

1. **Fork** el repositorio
2. **Crea rama** feature (`git checkout -b feature/amazing-feature`)
3. **Commit** cambios (`git commit -m 'Add amazing feature'`)
4. **Push** a la rama (`git push origin feature/amazing-feature`)
5. **Abre Pull Request**

### Código de Conducta

Respeta:
- ✅ Estándares de código
- ✅ Pruebas unitarias
- ✅ Documentación actualizada
- ✅ Seguridad & privacidad

---

## 📞 Soporte & Contacto

**Autor:** moviYa23 (César)  
**Email:** toby8129740@gmail.com  
**GitHub:** https://github.com/moviYa23  
**Issues:** https://github.com/moviYa23/MoviYa/issues

---

## 📄 Licencia

MoviYa está bajo licencia **MIT**.

```
MIT License

Copyright (c) 2026 moviYa23

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

Ver `LICENSE` para detalles completos.

---

## 🙏 Agradecimientos

Especial agradecimiento a:
- 🚀 Comunidad de código abierto
- 🔐 NIST (Post-Quantum Cryptography Standards)
- ⛓️ BNB Chain & Ethereum community
- 🤖 Proyectos de IA & ML

---

## 📚 Recursos Adicionales

### Documentación
- [Guía Completa del Centro de Control](./moviya-control-center-master-v25-guide.md)
- [Arquitectura Técnica](./moviya-infrastructure-blueprint.md)
- [Tokenómica MYA](./mya-tokenomics-guide-v1.md)

### Video & Multimedia
- 📹 [Análisis MoviYa V3.0](./Análisis_MoviYa_V3.mp4)
- 🎵 [Audio Explicativo](./MoviYa_V3.m4a)
- 📊 [Blueprints PDF](./MOVIYA_V3.0_MASTER_BLUEPRINT.pdf)

### Herramientas Externas
- [BlockScout (Explorer BNB)](https://bscscan.com)
- [Hardhat (Desarrollo Solidity)](https://hardhat.org)
- [Docker Hub (Imágenes)](https://hub.docker.com)

---

**Última actualización:** 2026-09-12  
**Versión Documentación:** 25.0

---

## ¡Comienza Ahora! 🚀

```bash
# Un comando para comenzar:
curl -fsSL https://raw.githubusercontent.com/moviYa23/MoviYa/main/moviya-quickstart-installer.sh | bash
```

**MoviYa: Transformando el Transporte con Ingeniería de Precisión y Criptografía Post-Cuántica** 🎯✨
