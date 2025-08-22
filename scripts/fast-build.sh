#!/bin/bash
# Fast build script for NMC project
# Optimized for single CPU systems with build time improvements

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Load build environment
if [ -f .env.build ]; then
    source .env.build
    log "Loaded build environment variables"
fi

# Function to build with optimizations
fast_build() {
    local service=${1:-all}
    
    log "Starting optimized build for: $service"
    
    # Enable BuildKit
    export DOCKER_BUILDKIT=1
    export COMPOSE_DOCKER_CLI_BUILD=1
    
    # Clean up previous failed builds
    log "Cleaning up previous builds..."
    docker system prune -f --volumes || true
    
    # Start build with optimizations
    if [ "$service" = "all" ]; then
        log "Building all services with parallel optimization..."
        
        # Build services in optimal order for caching
        log "Building dependencies first..."
        
        # Use parallel builds where possible
        docker compose build \
            --parallel \
            --progress=plain \
            nmc-server nmc-site nmc-storybook || {
            warning "Parallel build failed, trying sequential build..."
            docker compose build nmc-server
            docker compose build nmc-site  
            docker compose build nmc-storybook
        }
    else
        log "Building service: $service"
        docker compose build --progress=plain "$service"
    fi
    
    success "Build completed for: $service"
}

# Function for development build
dev_build() {
    log "Starting development build (with cache)..."
    
    export DOCKER_BUILDKIT=1
    export COMPOSE_DOCKER_CLI_BUILD=1
    
    # Build with cache, no cleanup
    docker compose build --parallel || {
        warning "Parallel build failed, trying sequential build..."
        docker compose build
    }
    
    success "Development build completed"
}

# Function to show build info
build_info() {
    log "Build Configuration:"
    echo "  Docker BuildKit: ${DOCKER_BUILDKIT:-disabled}"
    echo "  CPU Limit: ${CPU_LIMIT:-1}"
    echo "  Memory Limit: ${MEMORY_LIMIT:-4G}"
    echo "  Parallel Builds: ${PARALLEL_BUILDS:-1}"
    echo "  Cache Directory: ${CACHE_DIR:-.docker-cache}"
    echo ""
    
    log "System Resources:"
    echo "  Available CPUs: $(nproc)"
    echo "  Available Memory: $(free -h | grep '^Mem:' | awk '{print $2}')"
    echo "  Docker Info:"
    docker system df || true
}

# Function to clean build cache
clean_cache() {
    log "Cleaning build cache..."
    
    # Clean Docker cache
    docker system prune -f --volumes
    docker builder prune -f
    
    # Clean local cache directory
    if [ -d "${CACHE_DIR:-.docker-cache}" ]; then
        rm -rf "${CACHE_DIR:-.docker-cache}"
        log "Cleaned local cache directory"
    fi
    
    success "Cache cleaning completed"
}

# Help function
show_help() {
    cat << EOF
Fast Build Script for NMC Project

Usage: $0 [COMMAND] [SERVICE]

Commands:
  fast [service]     Fast build with optimizations (default: all)
  dev               Development build with cache
  clean             Clean build cache  
  info              Show build configuration
  help              Show this help

Services:
  all               Build all services (default)
  nmc-site          Build only site service
  nmc-server        Build only server service  
  nmc-storybook     Build only storybook service

Examples:
  $0 fast                    # Fast build all services
  $0 fast nmc-site          # Fast build only site
  $0 dev                    # Development build with cache
  $0 clean                  # Clean all caches
  
EOF
}

# Main command dispatcher
main() {
    case "${1:-fast}" in
        "fast")
            fast_build "${2:-all}"
            ;;
        "dev")
            dev_build
            ;;
        "clean")
            clean_cache
            ;;
        "info")
            build_info
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"