#!/bin/bash
# Docker optimization script for NMC project
# Provides utilities for optimized builds with caching and security scanning

set -euo pipefail

# Configuration
REGISTRY="${DOCKER_REGISTRY:-localhost:5000}"
CACHE_REPO="${REGISTRY}/nmc/cache"
BUILD_ARGS="--platform=linux/amd64 --progress=plain"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
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

# Build with optimized caching
build_optimized() {
    local service=$1
    local dockerfile_path
    local context="."
    
    case $service in
        "site")
            dockerfile_path="apps/nmc-site.v1/Dockerfile"
            ;;
        "server")
            dockerfile_path="apps/nmc-server.v1/Dockerfile"
            ;;
        "storybook")
            dockerfile_path="packages/nmc-storybook.v1/Dockerfile"
            ;;
        *)
            error "Unknown service: $service"
            exit 1
            ;;
    esac
    
    log "Building $service with optimized caching..."
    
    # Enable BuildKit and build with cache
    DOCKER_BUILDKIT=1 docker build \
        $BUILD_ARGS \
        --file "$dockerfile_path" \
        --cache-from "type=registry,ref=${CACHE_REPO}:${service}-deps" \
        --cache-from "type=registry,ref=${CACHE_REPO}:${service}-build" \
        --cache-to "type=registry,ref=${CACHE_REPO}:${service}-deps,mode=max" \
        --cache-to "type=registry,ref=${CACHE_REPO}:${service}-build,mode=max" \
        --tag "nmc-${service}:latest" \
        --tag "nmc-${service}:$(git rev-parse --short HEAD)" \
        "$context"
    
    success "Built $service successfully"
}

# Security scan
scan_image() {
    local image=$1
    log "Scanning $image for vulnerabilities..."
    
    # Run trivy scan
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
        aquasec/trivy:latest image \
        --severity HIGH,CRITICAL \
        --format table \
        "$image"
    
    # Generate SBOM
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$(pwd)/security-reports:/reports" \
        aquasec/trivy:latest image \
        --format cyclonedx \
        --output "/reports/${image//[:\/]/_}-sbom.json" \
        "$image"
    
    success "Security scan completed for $image"
}

# Analyze layer sizes
analyze_layers() {
    local image=$1
    log "Analyzing layer sizes for $image..."
    
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        wagoodman/dive:latest "$image"
}

# Clean build cache
clean_cache() {
    log "Cleaning build cache..."
    
    # Clean buildx cache
    docker buildx prune -f
    
    # Clean unused images
    docker image prune -f
    
    # Clean build cache
    docker builder prune -f
    
    success "Cache cleaned"
}

# Setup registry cache
setup_cache() {
    log "Setting up local registry for cache..."
    
    # Start local registry if not running
    if ! docker ps | grep -q "registry:2"; then
        docker run -d -p 5000:5000 --name registry registry:2
        success "Local registry started on port 5000"
    else
        log "Registry already running"
    fi
}

# Build all services
build_all() {
    log "Building all services with optimization..."
    
    setup_cache
    
    # Build in dependency order
    build_optimized "server"
    build_optimized "site" 
    build_optimized "storybook"
    
    success "All services built successfully"
}

# Generate build report
build_report() {
    log "Generating build report..."
    
    local report_file="build-report-$(date +%Y%m%d-%H%M%S).json"
    
    cat > "$report_file" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "git_commit": "$(git rev-parse HEAD)",
  "git_branch": "$(git rev-parse --abbrev-ref HEAD)",
  "images": [
$(docker images --format '    {"name": "{{.Repository}}", "tag": "{{.Tag}}", "size": "{{.Size}}", "created": "{{.CreatedAt}}"}' | grep "nmc-" | head -n -1 | sed 's/$/,/')
$(docker images --format '    {"name": "{{.Repository}}", "tag": "{{.Tag}}", "size": "{{.Size}}", "created": "{{.CreatedAt}}"}' | grep "nmc-" | tail -n 1)
  ]
}
EOF
    
    success "Build report saved to $report_file"
}

# Help function
show_help() {
    cat << EOF
Docker Optimization Utility for NMC Project

Usage: $0 [COMMAND] [OPTIONS]

Commands:
  build <service>     Build service with optimization (site|server|storybook)
  build-all          Build all services
  scan <image>       Run security scan on image
  analyze <image>    Analyze image layer sizes
  clean              Clean build cache
  setup-cache        Setup local registry cache
  report             Generate build report
  help               Show this help

Examples:
  $0 build site              # Build site with caching
  $0 build-all              # Build all services
  $0 scan nmc-site:latest   # Scan site image
  $0 analyze nmc-server     # Analyze server layers
  $0 clean                  # Clean cache

Environment Variables:
  DOCKER_REGISTRY           Registry for cache (default: localhost:5000)
EOF
}

# Main command dispatcher
main() {
    case "${1:-help}" in
        "build")
            if [[ -z "${2:-}" ]]; then
                error "Service name required. Use: site, server, or storybook"
                exit 1
            fi
            build_optimized "$2"
            ;;
        "build-all")
            build_all
            ;;
        "scan")
            if [[ -z "${2:-}" ]]; then
                error "Image name required"
                exit 1
            fi
            scan_image "$2"
            ;;
        "analyze")
            if [[ -z "${2:-}" ]]; then
                error "Image name required"
                exit 1
            fi
            analyze_layers "$2"
            ;;
        "clean")
            clean_cache
            ;;
        "setup-cache")
            setup_cache
            ;;
        "report")
            build_report
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Create security reports directory
mkdir -p security-reports

# Run main function
main "$@"
