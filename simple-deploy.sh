#!/bin/bash

# Simple NMC Core VPS Deployment Script
# Usage: ./simple-deploy.sh [start|stop|restart|status|logs]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if docker and docker-compose are available
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker compose version &> /dev/null; then
        error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    fi
    
    success "Docker and Docker Compose are available"
}

# Start services
start_services() {
    info "Starting NMC Core services..."
    docker compose up -d
    success "Services started successfully"
    show_status
}

# Stop services
stop_services() {
    info "Stopping NMC Core services..."
    docker compose down
    success "Services stopped successfully"
}

# Restart services
restart_services() {
    info "Restarting NMC Core services..."
    docker compose restart
    success "Services restarted successfully"
    show_status
}

# Show status
show_status() {
    info "Current service status:"
    docker compose ps
    echo ""
    info "Available endpoints:"
    echo "  🌐 Main site: http://localhost/"
    echo "  📚 Storybook: http://localhost/ui/"
    echo "  🔧 API: http://localhost/api/"
    echo "  ❤️  Health check: http://localhost/health"
}

# Show logs
show_logs() {
    local service="${1:-}"
    if [[ -n "${service}" ]]; then
        info "Showing logs for ${service}..."
        docker compose logs -f "${service}"
    else
        info "Showing logs for all services..."
        docker compose logs -f
    fi
}

# Build and start fresh
fresh_start() {
    info "Fresh deployment starting..."
    docker compose down --volumes
    docker compose up -d --build
    success "Fresh deployment completed"
    show_status
}

# Show help
show_help() {
    echo "Simple NMC Core VPS Deployment"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  start         Start all services"
    echo "  stop          Stop all services" 
    echo "  restart       Restart all services"
    echo "  status        Show service status"
    echo "  logs [svc]    Show logs (all or specific service)"
    echo "  fresh         Fresh deployment (rebuild and restart)"
    echo "  help          Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 start                 # Start all services"
    echo "  $0 logs nginx           # Show nginx logs"
    echo "  $0 fresh                # Fresh deployment"
}

# Main script logic
main() {
    local command="${1:-help}"
    
    case "${command}" in
        start)
            check_dependencies
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "${2:-}"
            ;;
        fresh)
            check_dependencies
            fresh_start
            ;;
        help|*)
            show_help
            ;;
    esac
}

# Run main function with all arguments
main "$@"