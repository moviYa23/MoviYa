#!/bin/bash
###############################################################################
# MoviYa Control Center Master V25.0 - QUICK START INSTALLER
# Automatización completa de instalación y configuración
# Plataforma: PC (4GB RAM) + Termux/Edge + BNB Chain
###############################################################################

set -euo pipefail

# ============================================================================
# COLORES Y FORMATO
# ============================================================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# ============================================================================
# VARIABLES GLOBALES
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_LOG="${SCRIPT_DIR}/install_$(date +%Y%m%d_%H%M%S).log"
VENV_DIR="${SCRIPT_DIR}/venv"
NODE_MODULES="${SCRIPT_DIR}/node_modules"

# ============================================================================
# FUNCIONES DE UTILIDAD
# ============================================================================

print_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                  MOVIYA V25.0 - QUICK START INSTALLER                     ║
║           Centro de Control Maestro (36 Dimensiones)                      ║
║                                                                           ║
║  Ecosistema: Transporte • E-Commerce • PQC Security • Governance & AI    ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${INSTALL_LOG}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $@${NC}" | tee -a "${INSTALL_LOG}"
}

log_success() {
    echo -e "${GREEN}✅ $@${NC}" | tee -a "${INSTALL_LOG}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $@${NC}" | tee -a "${INSTALL_LOG}"
}

log_error() {
    echo -e "${RED}❌ $@${NC}" | tee -a "${INSTALL_LOG}"
}

# Verificar si comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detector de SO
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi "microsoft" /proc/version 2>/dev/null; then
            echo "WSL2"
        else
            echo "Linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS"
    elif [[ -n "$TERMUX_VERSION" ]]; then
        echo "Termux"
    else
        echo "Unknown"
    fi
}

# ============================================================================
# VERIFICACIÓN DE REQUISITOS
# ============================================================================

check_requirements() {
    log_info "Verificando requisitos del sistema..."
    
    local missing_deps=()
    
    # Requisitos obligatorios
    local required_commands=("git" "curl" "bash")
    
    for cmd in "${required_commands[@]}"; do
        if ! command_exists "$cmd"; then
            missing_deps+=("$cmd")
            log_error "Falta: $cmd"
        else
            log_success "Encontrado: $cmd"
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Dependencias faltantes: ${missing_deps[*]}"
        return 1
    fi
    
    return 0
}

check_disk_space() {
    log_info "Verificando espacio en disco..."
    
    local available=$(df "$SCRIPT_DIR" | awk 'NR==2 {print $4}')
    local required=$((5 * 1024 * 1024))  # 5GB en KB
    
    if [[ $available -lt $required ]]; then
        log_warning "Espacio disponible: $(numfmt --to=iec $((available * 1024))) (se recomiendan 5GB)"
    else
        log_success "Espacio disponible: $(numfmt --to=iec $((available * 1024)))"
    fi
}

# ============================================================================
# INSTALACIÓN DE DEPENDENCIAS
# ============================================================================

install_system_deps() {
    local os=$(detect_os)
    
    log_info "Detectado SO: $os"
    
    case "$os" in
        Linux|WSL2)
            install_linux_deps
            ;;
        macOS)
            install_macos_deps
            ;;
        Termux)
            install_termux_deps
            ;;
        *)
            log_error "SO no soportado: $os"
            return 1
            ;;
    esac
}

install_linux_deps() {
    log_info "Instalando dependencias para Linux/WSL2..."
    
    if ! command_exists apt-get; then
        log_warning "apt-get no encontrado, omitiendo instalación de sistema"
        return 0
    fi
    
    log_info "Ejecutando: sudo apt-get update"
    sudo apt-get update 2>&1 | tee -a "${INSTALL_LOG}"
    
    local packages=(
        "bash" "curl" "wget" "git" "jq" "yq"
        "python3" "python3-pip" "python3-venv"
        "nodejs" "npm"
        "docker.io" "docker-compose"
        "postgresql" "postgresql-contrib"
        "redis-server" "redis-tools"
        "openssl" "cryptsetup"
        "net-tools" "dnsutils" "netcat" "nmap"
        "htop" "iotop" "sysstat" "git-lfs"
    )
    
    for pkg in "${packages[@]}"; do
        if dpkg -l | grep -q "^ii  $pkg"; then
            log_success "Ya instalado: $pkg"
        else
            log_info "Instalando: $pkg"
            sudo apt-get install -y "$pkg" 2>&1 | tee -a "${INSTALL_LOG}" || log_warning "Fallo al instalar: $pkg"
        fi
    done
    
    # Habilitar Docker
    log_info "Habilitando Docker daemon..."
    sudo systemctl enable docker 2>&1 | tee -a "${INSTALL_LOG}" || true
    sudo systemctl start docker 2>&1 | tee -a "${INSTALL_LOG}" || true
}

install_macos_deps() {
    log_info "Instalando dependencias para macOS..."
    
    if ! command_exists brew; then
        log_error "Homebrew no instalado. Instálalo desde: https://brew.sh"
        return 1
    fi
    
    log_info "Ejecutando: brew update"
    brew update 2>&1 | tee -a "${INSTALL_LOG}"
    
    local packages=(
        "bash" "curl" "wget" "git" "jq" "yq"
        "python3" "node" "postgresql" "redis"
        "openssl" "gnu-netcat" "nmap" "htop"
        "cask/cask/docker"
    )
    
    for pkg in "${packages[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            log_success "Ya instalado: $pkg"
        else
            log_info "Instalando: $pkg"
            brew install "$pkg" 2>&1 | tee -a "${INSTALL_LOG}" || log_warning "Fallo al instalar: $pkg"
        fi
    done
}

install_termux_deps() {
    log_info "Instalando dependencias para Termux..."
    
    log_info "Ejecutando: pkg update"
    pkg update -y 2>&1 | tee -a "${INSTALL_LOG}"
    
    local packages=(
        "bash" "curl" "wget" "git" "jq" "python"
        "nodejs" "postgresql" "redis"
        "openssl" "net-tools" "termux-api"
    )
    
    for pkg in "${packages[@]}"; do
        log_info "Instalando: $pkg"
        pkg install -y "$pkg" 2>&1 | tee -a "${INSTALL_LOG}" || log_warning "Fallo al instalar: $pkg"
    done
}

# ============================================================================
# CONFIGURACIÓN DE ENTORNO PYTHON
# ============================================================================

setup_python_venv() {
    log_info "Configurando entorno virtual Python..."
    
    if [[ -d "$VENV_DIR" ]]; then
        log_warning "Entorno virtual ya existe: $VENV_DIR"
        read -p "¿Recrear entorno? (y/n): " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$VENV_DIR"
        else
            return 0
        fi
    fi
    
    log_info "Creando venv: $VENV_DIR"
    python3 -m venv "$VENV_DIR" 2>&1 | tee -a "${INSTALL_LOG}"
    
    log_info "Activando venv..."
    source "${VENV_DIR}/bin/activate" || source "${VENV_DIR}/Scripts/activate"
    
    log_info "Actualizando pip..."
    pip install --upgrade pip setuptools wheel 2>&1 | tee -a "${INSTALL_LOG}"
    
    if [[ -f "${SCRIPT_DIR}/requirements.txt" ]]; then
        log_info "Instalando dependencias Python..."
        pip install -r "${SCRIPT_DIR}/requirements.txt" 2>&1 | tee -a "${INSTALL_LOG}"
        log_success "Dependencias Python instaladas"
    else
        log_warning "requirements.txt no encontrado"
    fi
}

# ============================================================================
# CONFIGURACIÓN DE ENTORNO NODE.JS
# ============================================================================

setup_nodejs_deps() {
    log_info "Configurando dependencias Node.js..."
    
    if [[ ! -f "${SCRIPT_DIR}/package.json" ]]; then
        log_warning "package.json no encontrado, omitiendo Node.js setup"
        return 0
    fi
    
    log_info "Ejecutando: npm install"
    npm install 2>&1 | tee -a "${INSTALL_LOG}"
    
    # Instalar herramientas globales
    log_info "Instalando herramientas globales..."
    npm install -g hardhat ethers web3 @openzeppelin/contracts 2>&1 | tee -a "${INSTALL_LOG}" || true
    
    log_success "Dependencias Node.js instaladas"
}

# ============================================================================
# CONFIGURACIÓN DE ENTORNO (.env)
# ============================================================================

setup_env_file() {
    log_info "Configurando archivo .env..."
    
    if [[ -f "${SCRIPT_DIR}/.env" ]]; then
        log_warning "Archivo .env ya existe"
        read -p "¿Sobrescribir? (y/n): " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    cat > "${SCRIPT_DIR}/.env" << 'EOF'
# ============================================================================
# MoviYa V25.0 - Configuración de Entorno
# ============================================================================

# ENTORNO & LOGGING
ENVIRONMENT=production
DEBUG=false
LOG_LEVEL=INFO

# DOCKER
DOCKER_COMPOSE_FILE=docker-compose-celeron-v25.yml

# BLOCKCHAIN & WEB3
BLOCKCHAIN_RPC=https://bsc-dataseed.binance.org:443
BLOCKCHAIN_NETWORK=bsc-mainnet
BLOCKCHAIN_PRIVATE_KEY=your_private_key_here
BLOCKCHAIN_PUBLIC_KEY=your_public_key_here

# BASE DE DATOS
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=moviya_production
POSTGRES_USER=moviya_admin
POSTGRES_PASSWORD=change_me_secure_password
POSTGRES_SSL_MODE=require

# REDIS
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=change_me_redis_password
REDIS_DB=0

# SEGURIDAD PQC (POST-QUANTUM CRYPTOGRAPHY)
PQC_ENABLED=true
PQC_ALGORITHM=kyber1024
PQC_SIGNATURE_ALGORITHM=dilithium5
PQC_HASH_ALGORITHM=sha3-256

# SERVICIOS PRINCIPALES
SENTIUMX_PORT=8787
SENTIUMX_HOST=0.0.0.0
MAYA_PORT=8888
MAYA_HOST=0.0.0.0
MASTER_ROUTER_PORT=8080
MASTER_ROUTER_HOST=0.0.0.0

# ALERTAS & NOTIFICACIONES
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
SLACK_WEBHOOK_URL=your_slack_webhook_here

# EMAIL (Para alertas de diagnóstico cada 6h)
EMAIL_ENABLED=true
EMAIL_SMTP_SERVER=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your_email@gmail.com
EMAIL_SMTP_PASSWORD=your_app_password_here
EMAIL_FROM=alerts@moviya.io
EMAIL_TO=your_email@example.com

# JWT & AUTENTICACIÓN
JWT_SECRET=your_long_random_secret_key_here
JWT_EXPIRATION_HOURS=24
JWT_REFRESH_EXPIRATION_DAYS=7

# TOKENÓMICA MYA
MYA_TOKEN_ADDRESS=0x0000000000000000000000000000000000000000
MYA_TOKEN_DECIMALS=18
MYA_SWARM_COMMISSION=0.10
MYA_PLATFORM_COMMISSION=0.05

# API KEYS EXTERNAS
CHAINLINK_ORACLE_ADDRESS=0x0000000000000000000000000000000000000000
INFURA_API_KEY=your_infura_key_here
ETHERSCAN_API_KEY=your_etherscan_key_here

# TERCER NIVEL - VALIDADORES
VALIDATOR_MIN_STAKE=1000
VALIDATOR_SLASH_PERCENT=10
VALIDATOR_LOCK_PERIOD_DAYS=7

# MODO SIMULACIÓN (Para testing)
SIMULATION_MODE=false
SIMULATION_USER_COUNT=10000
SIMULATION_DURATION_MINUTES=5

# DIRECTORIOS & PATHS
BACKUP_DIR=./backups
LOGS_DIR=./logs
CACHE_DIR=./cache
CONTRACTS_DIR=./contracts

# VERSIÓN
VERSION=25.0
BUILD_DATE=$(date +%Y-%m-%d)
RELEASE_CHANNEL=production
EOF

    log_success "Archivo .env creado: ${SCRIPT_DIR}/.env"
    log_warning "⚠️  IMPORTANTE: Edita .env con tus valores reales antes de producción"
    
    read -p "¿Editar .env ahora? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command_exists nano; then
            nano "${SCRIPT_DIR}/.env"
        elif command_exists vim; then
            vim "${SCRIPT_DIR}/.env"
        fi
    fi
}

# ============================================================================
# CONFIGURACIÓN DE DOCKER
# ============================================================================

setup_docker() {
    log_info "Verificando configuración de Docker..."
    
    if ! command_exists docker; then
        log_error "Docker no está instalado"
        return 1
    fi
    
    # Verificar Docker daemon
    if ! docker ps &>/dev/null; then
        log_warning "Docker daemon no está disponible, intentando iniciar..."
        
        if command_exists systemctl; then
            sudo systemctl start docker 2>&1 | tee -a "${INSTALL_LOG}" || true
        fi
    fi
    
    # Verificar docker-compose
    if ! command_exists docker-compose; then
        log_info "Instalando docker-compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    
    log_success "Docker configurado correctamente"
}

# ============================================================================
# VERIFICACIÓN DE PUERTOS
# ============================================================================

check_ports() {
    log_info "Verificando disponibilidad de puertos..."
    
    local ports=(8080 8787 8888 5432 6379 3000)
    
    for port in "${ports[@]}"; do
        if command_exists lsof; then
            if lsof -i ":$port" >/dev/null 2>&1; then
                log_warning "Puerto $port está en uso"
            else
                log_success "Puerto $port disponible"
            fi
        fi
    done
}

# ============================================================================
# PERMISOS & SEGURIDAD
# ============================================================================

setup_permissions() {
    log_info "Configurando permisos..."
    
    # Scripts ejecutables
    chmod +x "${SCRIPT_DIR}"/*.sh 2>/dev/null || true
    
    # Archivo .env con permisos restringidos
    if [[ -f "${SCRIPT_DIR}/.env" ]]; then
        chmod 600 "${SCRIPT_DIR}/.env"
        log_success "Permisos configurados: .env (600)"
    fi
    
    # Directorio de logs
    mkdir -p "${SCRIPT_DIR}/logs"
    chmod 700 "${SCRIPT_DIR}/logs"
    
    # Directorio de backups
    mkdir -p "${SCRIPT_DIR}/backups"
    chmod 700 "${SCRIPT_DIR}/backups"
}

# ============================================================================
# INICIALIZACIÓN DE SERVICIOS
# ============================================================================

init_services() {
    log_info "Inicializando servicios..."
    
    read -p "¿Deseas iniciar servicios Docker ahora? (y/n): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Saltando inicialización de servicios"
        return 0
    fi
    
    if [[ ! -f "${SCRIPT_DIR}/${DOCKER_COMPOSE_FILE}" ]]; then
        log_error "Archivo docker-compose no encontrado: ${DOCKER_COMPOSE_FILE}"
        return 1
    fi
    
    log_info "Iniciando contenedores..."
    docker-compose -f "${SCRIPT_DIR}/${DOCKER_COMPOSE_FILE}" up -d 2>&1 | tee -a "${INSTALL_LOG}"
    
    sleep 5
    
    log_info "Verificando estado de contenedores..."
    docker-compose -f "${SCRIPT_DIR}/${DOCKER_COMPOSE_FILE}" ps
}

# ============================================================================
# POST-INSTALACIÓN
# ============================================================================

post_install() {
    log_info "Ejecutando tareas de post-instalación..."
    
    # Crear scripts de acceso rápido
    cat > "${SCRIPT_DIR}/moviya-cc.sh" << 'SHELL_SCRIPT'
#!/bin/bash
# Acceso rápido al Centro de Control Maestro
cd "$(dirname "$0")"
source venv/bin/activate 2>/dev/null || true
exec ./moviya-control-center-master-v25.sh "$@"
SHELL_SCRIPT
    
    chmod +x "${SCRIPT_DIR}/moviya-cc.sh"
    log_success "Creado: moviya-cc.sh (acceso rápido)"
    
    # Crear enlace simbólico global (opcional)
    read -p "¿Crear enlace global /usr/local/bin/moviya-cc? (requiere sudo) (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo ln -sf "${SCRIPT_DIR}/moviya-cc.sh" /usr/local/bin/moviya-cc
        log_success "Enlace global creado: moviya-cc"
    fi
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

print_summary() {
    echo ""
    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                  ✅ INSTALACIÓN COMPLETADA EXITOSAMENTE                   ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}📋 PRÓXIMOS PASOS:${NC}"
    echo ""
    echo "1. Editar configuración:"
    echo "   nano ${SCRIPT_DIR}/.env"
    echo ""
    echo "2. Iniciar Centro de Control:"
    echo "   ./moviya-cc.sh"
    echo "   O: ${SCRIPT_DIR}/moviya-control-center-master-v25.sh"
    echo ""
    echo "3. Revisar logs:"
    echo "   tail -f ${INSTALL_LOG}"
    echo ""
    
    echo -e "${YELLOW}📚 DOCUMENTACIÓN:${NC}"
    echo "   Lee: moviya-control-center-master-v25-guide.md"
    echo ""
    
    echo -e "${PURPLE}🔗 ENLACES ÚTILES:${NC}"
    echo "   • Repositorio: https://github.com/moviYa23/MoviYa"
    echo "   • Documentación: docs/"
    echo "   • Logs: ${INSTALL_LOG}"
    echo ""
    
    echo -e "${BOLD}Gracias por usar MoviYa Control Center Master V25.0${NC}"
    echo ""
}

# ============================================================================
# PUNTO DE ENTRADA PRINCIPAL
# ============================================================================

main() {
    print_header
    
    log_info "Iniciando instalación de MoviYa Control Center Master V25.0"
    log_info "Log completo: ${INSTALL_LOG}"
    
    # 1. Verificación de requisitos
    if ! check_requirements; then
        log_error "Requisitos no cumplidos"
        exit 1
    fi
    
    check_disk_space
    
    # 2. Instalación de dependencias de sistema
    read -p "¿Instalar dependencias de sistema? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_system_deps
    fi
    
    # 3. Setup Python
    setup_python_venv
    
    # 4. Setup Node.js
    setup_nodejs_deps
    
    # 5. Configuración de .env
    setup_env_file
    
    # 6. Docker
    setup_docker
    
    # 7. Permisos
    setup_permissions
    
    # 8. Verificar puertos
    check_ports
    
    # 9. Inicializar servicios
    init_services
    
    # 10. Post-instalación
    post_install
    
    # 11. Resumen
    print_summary
    
    log_success "Instalación completada: $(date)"
}

# Ejecutar main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
