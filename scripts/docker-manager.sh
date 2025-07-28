#!/bin/bash

# NMC Docker Manager - Unified script for managing NMC services
# Usage: ./docker-manager.sh [command] [options]

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly COMPOSE_FILE="${PROJECT_ROOT}/docker-compose.yml"
readonly LOG_FILE="${PROJECT_ROOT}/logs/docker-manager.log"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Emoji for better UX
readonly SUCCESS="✅"
readonly ERROR="❌"
readonly INFO="ℹ️"
readonly WORKING="🔄"
readonly CLEAN="🧹"
readonly BUILD="🔨"
readonly START="🚀"
readonly STOP="⛔"

# Create logs directory if it doesn't exist
mkdir -p "${PROJECT_ROOT}/logs"

# Logging function
log() {
    echo -e "${1}" | tee -a "${LOG_FILE}"
}

# Error handling
error_exit() {
    log "${ERROR} ${RED}Error: $1${NC}"
    exit 1
}

# Success message
success() {
    log "${SUCCESS} ${GREEN}$1${NC}"
}

# Info message
info() {
    log "${INFO} ${BLUE}$1${NC}"
}

# Working message
working() {
    log "${WORKING} ${YELLOW}$1${NC}"
}

# Check if docker-compose is available
check_dependencies() {
    if ! command -v docker-compose &> /dev/null; then
        error_exit "docker-compose not found. Please install Docker Compose."
    fi
    
    if ! docker info &> /dev/null; then
        error_exit "Docker daemon is not running. Please start Docker."
    fi
}

# Change to project root
cd "${PROJECT_ROOT}" || error_exit "Cannot change to project root directory"

# Health check function
health_check() {
    local service="${1:-all}"
    
    if [[ "${service}" == "all" ]]; then
        info "Checking health of all services..."
        docker-compose ps --services | while read -r svc; do
            if docker-compose ps "${svc}" | grep -q "healthy\|Up"; then
                success "Service ${svc} is healthy"
            else
                log "${ERROR} ${RED}Service ${svc} is not healthy${NC}"
            fi
        done
    else
        if docker-compose ps "${service}" | grep -q "healthy\|Up"; then
            success "Service ${service} is healthy"
        else
            error_exit "Service ${service} is not healthy"
        fi
    fi
}

# Build services
build_services() {
    local service="${1:-}"
    local force_rebuild="${2:-false}"
    
    if [[ "${force_rebuild}" == "true" ]]; then
        working "Force rebuilding services..."
        if [[ -n "${service}" ]]; then
            docker-compose build --no-cache "${service}"
        else
            docker-compose build --no-cache
        fi
    else
        working "Building services..."
        if [[ -n "${service}" ]]; then
            docker-compose build "${service}"
        else
            docker-compose build
        fi
    fi
    
    success "Build completed successfully"
}

# Start services
start_services() {
    local service="${1:-}"
    
    working "Starting services..."
    if [[ -n "${service}" ]]; then
        docker-compose up -d "${service}"
    else
        docker-compose up -d
    fi
    
    success "Services started successfully"
}

# Stop services
stop_services() {
    local service="${1:-}"
    
    working "Stopping services..."
    if [[ -n "${service}" ]]; then
        docker-compose stop "${service}"
    else
        docker-compose stop
    fi
    
    success "Services stopped successfully"
}

# Restart services
restart_services() {
    local service="${1:-}"
    
    working "Restarting services..."
    if [[ -n "${service}" ]]; then
        docker-compose restart "${service}"
    else
        docker-compose restart
    fi
    
    success "Services restarted successfully"
}

# Clean Docker resources
clean_docker() {
    working "Cleaning Docker resources..."
    
    # Stop all containers if running
    docker-compose down 2>/dev/null || true
    
    # Remove stopped containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused volumes
    docker volume prune -f
    
    # Remove unused networks
    docker network prune -f
    
    success "Docker cleanup completed"
}

# Rebuild specific service
rebuild_service() {
    local service="${1}"
    
    if [[ -z "${service}" ]]; then
        error_exit "Service name is required for rebuild"
    fi
    
    working "Rebuilding service: ${service}"
    
    # Stop the service
    docker-compose stop "${service}" 2>/dev/null || true
    
    # Remove the container
    docker-compose rm -f "${service}" 2>/dev/null || true
    
    # Build with no cache
    docker-compose build --no-cache "${service}"
    
    # Start the service
    docker-compose up -d "${service}"
    
    success "Service ${service} rebuilt successfully"
}

# Show logs
show_logs() {
    local service="${1:-}"
    local follow="${2:-false}"
    
    if [[ "${follow}" == "true" ]]; then
        if [[ -n "${service}" ]]; then
            docker-compose logs -f "${service}"
        else
            docker-compose logs -f
        fi
    else
        if [[ -n "${service}" ]]; then
            docker-compose logs --tail=100 "${service}"
        else
            docker-compose logs --tail=100
        fi
    fi
}

# Show status
show_status() {
    info "Docker Compose Services Status:"
    docker-compose ps
    
    echo ""
    info "Docker System Information:"
    docker system df
}

# Deploy (full rebuild and restart)
deploy() {
    working "Starting full deployment..."
    
    # Stop all services
    docker-compose down
    
    # Clean up
    clean_docker
    
    # Build all services
    build_services "" "true"
    
    # Start all services
    start_services
    
    # Wait for services to be ready
    sleep 10
    
    # Health check
    health_check
    
    success "Deployment completed successfully"
}

# Show usage
usage() {
    echo "NMC Docker Manager"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  start [service]           Start all services or specific service"
    echo "  stop [service]            Stop all services or specific service"
    echo "  restart [service]         Restart all services or specific service"
    echo "  build [service] [--force] Build all services or specific service"
    echo "  rebuild [service]         Force rebuild and restart specific service"
    echo "  logs [service] [--follow] Show logs for all services or specific service"
    echo "  status                    Show status of all services"
    echo "  health [service]          Check health of all services or specific service"
    echo "  clean                     Clean Docker resources"
    echo "  deploy                    Full deployment (clean, build, start)"
    echo ""
    echo "Services: nmc-site, nmc-server, nmc-storybook, nginx"
    echo ""
    echo "Examples:"
    echo "  $0 start                  # Start all services"
    echo "  $0 start nmc-site         # Start only nmc-site"
    echo "  $0 rebuild nmc-server     # Rebuild and restart nmc-server"
    echo "  $0 logs nmc-site --follow # Follow logs for nmc-site"
    echo "  $0 build --force          # Force rebuild all services"
}

# Main command handler
main() {
    check_dependencies
    
    local command="${1:-}"
    local service="${2:-}"
    local option="${3:-}"
    
    case "${command}" in
        "start")
            start_services "${service}"
            ;;
        "stop")
            stop_services "${service}"
            ;;
        "restart")
            restart_services "${service}"
            ;;
        "build")
            local force_rebuild="false"
            if [[ "${service}" == "--force" ]] || [[ "${option}" == "--force" ]]; then
                force_rebuild="true"
                if [[ "${service}" == "--force" ]]; then
                    service=""
                fi
            fi
            build_services "${service}" "${force_rebuild}"
            ;;
        "rebuild")
            rebuild_service "${service}"
            ;;
        "logs")
            local follow="false"
            if [[ "${option}" == "--follow" ]] || [[ "${option}" == "-f" ]]; then
                follow="true"
            fi
            show_logs "${service}" "${follow}"
            ;;
        "status")
            show_status
            ;;
        "health")
            health_check "${service}"
            ;;
        "clean")
            clean_docker
            ;;
        "deploy")
            deploy
            ;;
        "help"|"--help"|"-h"|"")
            usage
            ;;
        *)
            error_exit "Unknown command: ${command}. Use 'help' for usage information."
            ;;
    esac
}

# Execute main function with all arguments
main "$@"
