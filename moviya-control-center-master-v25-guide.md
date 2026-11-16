# 🎯 MoviYa Control Center Master V25.0
## Centro de Control Maestro - 36 Dimensiones

**Versión:** 25.0  
**Estado:** Producción (CIS Benchmark & DevSecOps)  
**Ecosistema:** Transporte • E-Commerce • PQC Security • Governance & AI Swarm  
**Plataforma Soportada:** PC (4GB RAM) + Termux/Edge + BNB Chain

---

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Instalación](#instalación)
3. [Uso del Centro de Control](#uso-del-centro-de-control)
4. [Opciones Disponibles (36 Dimensiones)](#opciones-disponibles)
5. [Configuración Avanzada](#configuración-avanzada)
6. [Troubleshooting](#troubleshooting)
7. [Seguridad & Mejores Prácticas](#seguridad--mejores-prácticas)

---

## 🔧 Requisitos Previos

### Sistema Operativo
- **Linux/WSL2:** Ubuntu 20.04 LTS o superior
- **macOS:** BigSur o superior (con Homebrew)
- **Termux (Android):** Linux Proot con Bash 5.0+

### Dependencias Obligatorias
```bash
# Ubuntu/Debian/WSL2
sudo apt-get update
sudo apt-get install -y \
  bash curl wget git jq yq \
  docker docker-compose \
  python3 python3-pip python3-venv \
  nodejs npm \
  postgresql postgresql-contrib \
  redis-server redis-tools \
  openssl cryptsetup \
  net-tools dnsutils netcat nmap \
  htop iotop sysstat \
  git-lfs

# macOS
brew install bash curl wget git jq yq \
  docker docker-compose \
  python3 node postgresql redis \
  openssl cryptsetup \
  gnu-netcat nmap htop iotop

# Termux (Android)
pkg install -y bash curl wget git jq python nodejs postgresql redis
```

### Dependencias Python
```bash
cd /ruta/a/MoviYa
python3 -m venv venv
source venv/bin/activate  # O: source venv/Scripts/activate (Windows)
pip install -r requirements.txt
```

### Dependencias Node.js
```bash
npm install -g hardhat ethers web3 @openzeppelin/contracts
npm install  # En la raíz del proyecto
```

---

## 📥 Instalación

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/moviYa23/MoviYa.git
cd MoviYa
```

### Paso 2: Configurar Permisos
```bash
# Hacer el script ejecutable
chmod +x moviya-control-center-master-v25.sh

# Opcional: Instalar globalmente
sudo cp moviya-control-center-master-v25.sh /usr/local/bin/moviya-cc
sudo chmod +x /usr/local/bin/moviya-cc
```

### Paso 3: Configurar Variables de Entorno
```bash
# Copiar plantilla de configuración
cp .env.example .env

# Editar .env con tus datos
nano .env
```

**Variables Críticas en `.env`:**
```env
# Blockchain & Web3
BLOCKCHAIN_RPC=https://bsc-dataseed.binance.org:443
BLOCKCHAIN_PRIVATE_KEY=your_private_key_here
BLOCKCHAIN_NETWORK=bsc-testnet

# Infraestructura
DOCKER_COMPOSE_FILE=docker-compose-celeron-v25.yml
REDIS_HOST=localhost
REDIS_PORT=6379
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=moviya_production
POSTGRES_USER=moviya_admin
POSTGRES_PASSWORD=secure_password_here

# Seguridad PQC
PQC_ENABLED=true
PQC_ALGORITHM=kyber1024
PQC_SIGNATURE_ALGORITHM=dilithium5

# Servicios
SENTIUMX_PORT=8787
MAYA_PORT=8888
MASTER_ROUTER_PORT=8080

# Monitoreo & Alertas
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
SLACK_WEBHOOK_URL=your_slack_webhook_here
EMAIL_SMTP_SERVER=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_ALERTS=your_email@example.com

# Desarrollo
ENVIRONMENT=production
DEBUG=false
LOG_LEVEL=INFO
```

### Paso 4: Inicializar Infraestructura
```bash
# Construir contenedores Docker
docker-compose -f docker-compose-celeron-v25.yml build

# Iniciar servicios base
docker-compose -f docker-compose-celeron-v25.yml up -d

# Verificar estado
docker-compose -f docker-compose-celeron-v25.yml ps
```

---

## 🚀 Uso del Centro de Control

### Ejecución Básica
```bash
# Método 1: Script local
./moviya-control-center-master-v25.sh

# Método 2: Instalación global
moviya-cc

# Método 3: Con Python (alternativa)
python3 moviya-control-center-master-v25.py
```

### Pantalla Principal
```
===================================================================
         MOVIYA V25.0 • CENTRO DE CONTROL MAESTRO (36 DIMENSIONES)
======================================================================
Ecosistema: Transporte • E-Commerce • PQC Security • Governance & AI Swarm
Estándar: CIS Benchmark & DevSecOps Robustness (0 Errores)
----------------------------------------------------------------------
[Menú interactivo con 36 opciones + 1 salida]
----------------------------------------------------------------------
Selecciona una opción [0-36]:
```

---

## 🎯 Opciones Disponibles

### CATEGORÍA 1: INFRAESTRUCTURA & DESPLIEGUE

#### [1] 🚀 Deploy & Verificar Infraestructura Total
**Descripción:** Despliegue completo de todos los servicios y validación de integridad.

```bash
# Ejecuta automáticamente:
- docker-compose up
- Health checks de todos los servicios
- Validación de conectividad de red
- Pruebas de base de datos
- Verificación de certificados SSL/TLS
```

**Salida esperada:**
```
✅ Docker Daemon: Running
✅ PostgreSQL: Conectado (conexión exitosa)
✅ Redis: Conectado (ping/pong)
✅ Blockchain RPC: Respondiendo
✅ Frontend React: Compilado
✅ Infraestructura lista para producción
```

---

#### [2] 🐋 Audit de Contenedores Docker
**Descripción:** Validación de seguridad de imágenes Docker y configuración de docker-compose.

```bash
# Verifica:
- Vulnerabilidades en capas de imagen
- Configuración de seguridad (uid/gid)
- Limites de recursos (memory, CPU)
- Volúmenes y permisos
- Red y expuestos de puertos
```

**Comando directo:**
```bash
bash docker-compose-linter.sh --full-scan
```

---

#### [3] 🔐 Autenticación Criptográfica PQC LEGO
**Descripción:** Sistema de autenticación resistente a computación cuántica.

```bash
# Genera y verifica:
- Pares de claves Kyber-1024
- Tokens JWT firmados con Dilithium-5
- Certificados X.509 post-cuánticos
- Validación de LEGO (LDAP-inspired Group Signatures)
```

**Flujo de autenticación:**
```
Usuario → Solicitud → PQC Auth LEGO → Kyber Encapsulación → 
JWT Dilithium → Sesión Validada ✅
```

---

### CATEGORÍA 2: AUDITORÍA & SEGURIDAD

#### [4] 🔍 Auditoría Estática de Código
**Descripción:** Escaneo de vulnerabilidades en código fuente (Python, Go, JavaScript, Solidity).

```bash
# Herramientas utilizadas:
- pylint & bandit (Python)
- golangci-lint (Go)
- ESLint & Snyk (JavaScript)
- Slither (Solidity Smart Contracts)
```

**Genera reporte:**
```
📊 Resumen de Auditoría:
  - Vulnerabilidades críticas: 0
  - Vulnerabilidades altas: 2 (revisar)
  - Warnings: 5
  - Líneas analizadas: 45,230
  - Cobertura de código: 92%
```

---

#### [5] 🛡️ Hardening de Sistema Ubuntu/WSL2
**Descripción:** Fortalecimiento de seguridad del SO con CIS Benchmark v1.1.0.

```bash
# Implementa:
- Kernel hardening (sysctl)
- Firewall UFW rules
- SELinux/AppArmor policies
- SSH hardening (desabilitar root, cambiar puerto)
- Limite de recursos (ulimits)
- Auditoría de sistema (auditd)
```

**Estado post-hardening:**
```
✅ CIS Benchmark Score: 8.5/10
✅ SSH: Puerto 2222 (no-root login)
✅ Firewall: UFW ENABLED
✅ Core dumps: DISABLED
✅ Audit logging: ACTIVE
```

---

#### [6] 📜 Cronjob de Seguridad de Sistema
**Descripción:** Automatización de tareas de hardening y monitoreo.

```bash
# Cronjobs programados:
0 2 * * * - Verificación de integridad de archivos (aide)
0 3 * * 0 - Análisis de logs de seguridad
0 4 * * * - Escaneo de puertos abiertos
0 5 * * * - Actualización de definiciones malware
```

---

### CATEGORÍA 3: RENDIMIENTO & MONITOREO

#### [7] ⚡ Benchmark de Latencias Redis
**Descripción:** Pruebas de rendimiento en Redis cluster con 10K clientes.

```bash
# Mide:
- Latencia GET/SET promedio
- Throughput (ops/sec)
- Distribución de latencias (p50, p95, p99)
- Capacidad de cluster
```

**Salida típica:**
```
Redis Benchmark Results:
  GET: 0.45ms (avg), 150,000 ops/sec
  SET: 0.52ms (avg), 145,000 ops/sec
  P95 Latency: 2.1ms
  P99 Latency: 5.8ms
  ✅ Cumple SLA (< 10ms)
```

---

#### [8] 📊 Monitoreo de Rendimiento en Tiempo Real
**Descripción:** Dashboard en vivo de métricas del sistema.

```bash
# Monitorea:
- CPU (por core)
- Memoria RAM (free, used, buffers)
- I/O Disk (read/write throughput)
- Red (bytes in/out)
- Procesos TOP (por CPU, memoria)
- Temperaturas (si disponible)
```

---

#### [9] 📦 Sincronización y Respaldo de Archivos
**Descripción:** Backup automatizado con verificación de integridad.

```bash
# Realiza:
- Snapshot de base de datos PostgreSQL
- Backup de Redis persistence
- Sincronización con directorio remoto (rsync)
- Rotación de backups (retención 7 días)
- Verificación de checksums SHA256
```

---

#### [10] 🌐 Auditoría Completa de Red
**Descripción:** Análisis profundo de conectividad y configuración de red.

```bash
# Verifica:
- Interfaces activas (IP, MAC, MTU)
- Rutas de red
- Puertos abiertos y conexiones establecidas
- DNS resolution
- Latencia a servidores críticos
- Firewall rules (iptables/nftables)
```

---

### CATEGORÍA 4: BLOCKCHAIN & SMART CONTRACTS

#### [11] 🔑 Verificación de Hashes de Smart Contracts
**Descripción:** Validación de integridad de contratos inteligentes compilados.

```bash
# Verifica:
- Hash SHA256 de archivos .sol
- Bytecode en cadena vs local
- Sourcemap de compilación
- Versión de solc utilizada
```

---

#### [12] 🎯 Pruebas de Estrés 10K Usuarios Concurrentes
**Descripción:** Simulación de carga máxima del sistema con 10,000 usuarios virtuales.

```bash
# Simula:
- Solicitudes HTTP concurrentes
- Transacciones blockchain
- Operaciones de base de datos
- Streaming de GPS en tiempo real
- Pagos y comisiones
```

**Resultado esperado:**
```
Stress Test Report:
  Usuarios concurrentes: 10,000
  Duración: 5 minutos
  Solicitudes totales: 1,250,000
  Tasa de éxito: 99.8%
  Latencia P95: 245ms
  ✅ Sistema soporta producción
```

---

#### [13] 🔏 Verificador de Checksums de Firmware PQC
**Descripción:** Validación de firmware post-cuántico en dispositivos edge.

```bash
# Verifica:
- Checksums SHA3-256 de firmwares
- Firmas Dilithium-5
- Versión de runtime PQC
- Integridad de librerías criptográficas
```

---

#### [14] 🛑 Simulación de Intrusión y Respuesta Defensiva
**Descripción:** Red team ejercicio para validar defensas.

```bash
# Simula ataques:
- Inyección SQL
- XSS payloads
- Fuerza bruta en endpoints
- Replay attacks
- DoS/DDoS
- Privilege escalation

# Valida respuestas:
- Rate limiting
- WAF rules
- IDS/IPS alerts
- Auto-bloqueo de IPs
```

---

### CATEGORÍA 5: SECRETOS & ENTORNO

#### [15] 🔑 Auditoría de Secretos y Entorno (.env)
**Descripción:** Validación de exposición de credenciales sensibles.

```bash
# Busca y reporta:
- Claves privadas expuestas
- Contraseñas en archivos
- Tokens de API hardcodeados
- Archivos .env no gitignored
- Secretos en logs
```

---

#### [16] ⚙️ Auditar Configuración de Hardhat
**Descripción:** Validación de config de compilación y test de Solidity.

```bash
# Verifica:
- hardhat.config.js sintaxis
- Solc compiler version
- Network configurations
- Gas reporter setup
- Test framework integration
```

---

#### [17] 🚦 Inspeccionar Tráfico de Red
**Descripción:** Análisis de paquetes de red en tiempo real.

```bash
# Captura y analiza:
- Protocolos (TCP, UDP, ICMP)
- Aplicaciones de capa 7
- DNS queries
- TLS handshakes
- WebSocket frames
```

---

### CATEGORÍA 6: IA & ORQUESTACIÓN

#### [18] 🤖 Iniciar Orquestador SentiumX
**Descripción:** Sistema de inteligencia artificial distribuida para gobernanza autónoma.

```bash
# Funciones:
- Orquestación de microservicios
- Decisiones autónomas (DAO)
- Análisis de anomalías
- Optimización de rutas (transporte)
- Distribución de recompensas
```

**Estado del sistema:**
```
SentiumX v1.0 Initialized:
  - IA Nodes: 5 activos
  - Consensus: Byzantine Fault Tolerant
  - Latencia decisión: 234ms
  - Governanza: Active DAO
```

---

#### [19] 🔌 Tunelizador Móvil Termux PQC
**Descripción:** Túnel criptográfico post-cuántico para dispositivos edge (Android/Termux).

```bash
# Características:
- Encriptación Kyber-1024 extremo-a-extremo
- Compresión de datos (zstd)
- Sincronización con PC principal
- Batería optimizada (3x eficiencia)
```

**Uso:**
```bash
# En Termux:
pqc-mobile-tunnel.sh --mode server --port 9999 --pqc kyber

# En PC:
pqc-mobile-tunnel.sh --mode client --remote 192.168.1.100:9999
```

---

### CATEGORÍA 7: FRONTEND & UI

#### [20] 🖥️ Linter de Compilación Frontend React
**Descripción:** Validación de build de React y Webpack.

```bash
# Verifica:
- ESLint warnings/errors
- TypeScript strict mode
- Bundle size analysis
- Unused imports/exports
- Performance metrics (Lighthouse)
```

---

### CATEGORÍA 8: SESIONES & SEGURIDAD ACTIVA

#### [21] 🔄 Monitor de Sesiones Activas y Sesión Hijack
**Descripción:** Detección de sesiones anómalas en tiempo real.

```bash
# Monitorea:
- Sesiones activas por usuario
- IP y User-Agent changes
- Ubicación geográfica
- Detección de sesión hijacking
- Auto-invalidación de sesiones sospechosas
```

---

#### [22] 🧪 Pruebas de Integración PQC y Oráculos
**Descripción:** Tests end-to-end de componentes criptográficos y oráculos de datos.

```bash
# Prueba:
- Integración PQC LEGO
- Respuestas de oráculos Chainlink
- Sincronización de datos blockchain
- Validación de transacciones
```

---

### CATEGORÍA 9: VULNERABILIDADES & PUERTOS

#### [23] 🛡️ Escáner de Vulnerabilidades de Dependencias
**Descripción:** Auditoría de librerías con CVEs conocidos.

```bash
# Utiliza:
- npm audit (Node.js)
- pip-audit (Python)
- Trivy (Docker images)
- Snyk (SaaS scanning)
```

---

#### [24] 🔌 Auditor de Puertos Locales y Firewalls
**Descripción:** Mapeo y análisis de puertos abiertos.

```bash
# Detecta:
- Puertos escuchando (netstat)
- Procesos asociados
- Servicios no autorizados
- Reglas de firewall activas
```

---

### CATEGORÍA 10: BASE DE DATOS & DATOS

#### [25] 🐘 Ejecutar Migración de Base de Datos PostgreSQL
**Descripción:** Ejecución de migraciones de schema de BD.

```bash
# Realiza:
- Backup previo a migración
- Ejecución de scripts de migración
- Validación de integridad
- Rollback automático en caso de error
```

---

#### [26] 🚗 Inyectar 5,000 Viajes Históricos Simulados
**Descripción:** Generación de datos históricos para pruebas y análisis.

```bash
# Genera:
- 5,000 viajes con GPS simulado
- Cálculo de tarifas y comisiones
- Datos de conductor y pasajero
- Timestamps históricos
```

---

#### [27] 📈 Analíticas Financieras y Comisiones del Enjambre
**Descripción:** Reporte de métricas financieras y distribución de recompensas.

```bash
# Calcula:
- Ingresos totales
- Comisiones del enjambre
- Tokens MYA distribuidos
- ROI de nodos validadores
```

---

### CATEGORÍA 11: BLOCKCHAIN & TOKENS

#### [28] 💎 Desplegar y Sincronizar MYA Utility Token (BNB Chain)
**Descripción:** Despliegue del token ERC-20/ERC-721 en BNB Chain.

```bash
# Realiza:
- Compilación de contratos Solidity
- Despliegue en BNB testnet/mainnet
- Verificación en BlockScout
- Inicialización de parámetros tokenómicos
```

---

#### [29] 🔄 Sincronizar ABIs de Solidity con React Frontend
**Descripción:** Generación automática de tipos TypeScript desde ABIs.

```bash
# Genera:
- Tipos TS para contratos
- Hooks de React (usContract)
- Llamadas de función type-safe
- Eventos listeners
```

---

### CATEGORÍA 12: CORPORACIÓN AUTÓNOMA

#### [30] 🏛️ Inicializar Corporación Autónoma de IAs Éticas (SentiumX)
**Descripción:** Setup de DAO descentralizada con gobernanza IA.

```bash
# Inicializa:
- Contrato de gobernanza (DAO)
- Tokens de votación
- Periodo de propuestas
- Threshold de quórum
```

---

#### [31] 📱 Iniciar / Monitorear Bot de Alertas Telegram (SentiumX Bridge)
**Descripción:** Bot de notificaciones en tiempo real vía Telegram.

```bash
# Notificaciones:
- Alertas de seguridad
- Eventos blockchain
- Métricas de rendimiento
- Cambios de estado de enjambre
```

---

### CATEGORÍA 13: DIAGNÓSTICO & RECUPERACIÓN

#### [32] 🏥 Diagnóstico Avanzado de Plataforma, Email (6h) & Auto-Reparación
**Descripción:** Sistema de autodiagnóstico y recuperación automática.

```bash
# Diagnostica:
- Health checks exhaustivos
- Performance bottlenecks
- Fallos de servicios
- Inconsistencias de datos

# Repara:
- Reinicia servicios fallidos
- Resincroniza bases de datos
- Limpia caché corrupto
- Notifica vía email cada 6h
```

---

#### [33] 📊 Monitor de Despliegues en Tiempo Real GitHub Actions
**Descripción:** Seguimiento de CI/CD pipeline en GitHub Actions.

```bash
# Monitorea:
- Estado de workflows
- Logs de build/test
- Duración de jobs
- Historial de despliegues
```

---

### CATEGORÍA 14: NODOS AUTÓNOMOS

#### [34] 🌐 Gestor & Orquestador de Nodo Autónomo MAYA-X Core V1.0 (:8787)
**Descripción:** Orquestador de nodo descentralizado MAYA-X.

```bash
# Características:
- Validación de transacciones
- Consenso BFT
- Replicación de estado
- Puerto: 8787
```

---

### CATEGORÍA 15: CRIPTOGRAFÍA POST-CUÁNTICA

#### [35] 🔐 Auditoría y Verificación de Túnel Cifrado Post-Cuántico Kyber-1024
**Descripción:** Validación de seguridad criptográfica del túnel Kyber-1024.

```bash
# Verifica:
- Encapsulación Kyber correcta
- Tamaño de clave (1024-bit)
- Decapsulación exitosa
- Resistencia post-cuántica
```

---

#### [36] ⚡ Simulador de Ataque de Fuerza Bruta Cuántica PQC
**Descripción:** Simulación teórica de ataque cuántico contra primitivas PQC.

```bash
# Resultado esperado:
✅ Kyber-1024: RESISTENTE (2^256+ operaciones)
✅ Dilithium-5: RESISTENTE
✅ SPHINCS+-SHA256: RESISTENTE
✅ Todas las primitivas PQC SEGURAS
```

---

## ⚙️ Configuración Avanzada

### Tunelización Remota (PC ↔ Termux)

**Caso de uso:** Sincronizar desarrollo entre PC y dispositivo móvil

```bash
# En PC (puerto 9999 escuchando):
ssh -R 9999:localhost:8080 user@termux_device

# En Termux (conectar a puerto 9999):
pqc-mobile-tunnel.sh --mode client --remote localhost:9999
```

### Monitoreo con Prometheus & Grafana

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'moviya'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'redis'
    static_configs:
      - targets: ['localhost:6379']
```

### Alertas con Alertmanager

```yaml
# alertmanager.yml
route:
  receiver: 'telegram'

receivers:
  - name: 'telegram'
    telegram_configs:
      - bot_token: 'YOUR_BOT_TOKEN'
        chat_id: 'YOUR_CHAT_ID'
```

---

## 🐛 Troubleshooting

### Problema: "Script not found"
```bash
# Solución 1: Verificar permisos
ls -la moviya-control-center-master-v25.sh
chmod +x moviya-control-center-master-v25.sh

# Solución 2: Ejecutar con bash explícitamente
bash moviya-control-center-master-v25.sh
```

### Problema: Docker daemon no responde
```bash
# Verificar estado
docker ps

# Reiniciar daemon
sudo systemctl restart docker

# En WSL2
wsl --shutdown
# Reiniciar WSL
```

### Problema: Permisos de sudo requeridos
```bash
# Agregar usuario a grupo docker (sin sudo)
sudo usermod -aG docker $USER
newgrp docker
```

### Problema: Puertos en uso
```bash
# Encontrar proceso usando puerto
sudo lsof -i :8787

# Liberar puerto
sudo kill -9 <PID>
```

### Problema: Redis no conecta
```bash
# Verificar servicio
systemctl status redis-server

# Reiniciar Redis
sudo systemctl restart redis-server

# Conectar localmente
redis-cli ping
# Debería responder: PONG
```

---

## 🔒 Seguridad & Mejores Prácticas

### 1. Rotación de Claves
```bash
# Cada 90 días
python3 pqc-auth-lego.py --rotate-keys

# Verificar claves activas
python3 pqc-auth-lego.py --list-keys
```

### 2. Backups Cifrados
```bash
# Backup con cifrado AES-256
bash backup-v3.sh --cipher aes-256 --compress zstd
```

### 3. Auditoría de Logs
```bash
# Revisar logs de seguridad
sudo journalctl -u moviya-system -n 100 --no-pager

# Buscar eventos sospechosos
sudo journalctl SYSLOG_IDENTIFIER=moviya | grep -i error
```

### 4. Validación de Integridad
```bash
# Verificar checksums de scripts
sha256sum -c scripts.sha256

# Regenerar checksums
find ./scripts -type f -exec sha256sum {} \; > scripts.sha256
```

---

## 📞 Contacto & Soporte

**Autor:** moviYa23  
**Email:** toby8129740@gmail.com  
**GitHub:** https://github.com/moviYa23/MoviYa  
**Documentación:** Ver `docs/` en repositorio

---

## 📄 Licencia

MoviYa es de código abierto bajo licencia MIT.  
Ver `LICENSE` para detalles completos.

---

**Última actualización:** 2026-09-12  
**Versión de documento:** 1.0
