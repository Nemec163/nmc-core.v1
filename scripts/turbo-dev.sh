#!/bin/bash

# Turbo Development Helper Script
# This script provides optimized commands for local development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "${BLUE}===================================${NC}"
    echo -e "${BLUE}🚀 Turbo Development Helper${NC}"
    echo -e "${BLUE}===================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Main functions
setup() {
    print_header
    print_info "Setting up development environment..."
    
    # Install dependencies with cache optimization
    print_info "Installing dependencies..."
    pnpm install --frozen-lockfile
    
    # Build all packages first
    print_info "Building all packages..."
    pnpm build
    
    print_success "Setup completed!"
}

dev() {
    print_header
    print_info "Starting development servers..."
    
    # Run development with optimized caching
    pnpm dev
}

build_optimized() {
    print_header
    print_info "Running optimized build..."
    
    # Clean everything first
    print_info "Cleaning build artifacts..."
    pnpm clean
    
    # Run parallel build with caching
    print_info "Building with Turbo optimization..."
    pnpm run build --parallel --cache-dir=.turbo
    
    print_success "Optimized build completed!"
}

test_all() {
    print_header
    print_info "Running all tests..."
    
    # Run tests in parallel with caching
    pnpm run test --parallel --cache-dir=.turbo
    pnpm run test:e2e --cache-dir=.turbo
    
    print_success "All tests completed!"
}

ci_local() {
    print_header
    print_info "Running CI pipeline locally..."
    
    # Simulate CI environment
    print_info "Running linting..."
    pnpm lint
    
    print_info "Running type checking..."
    pnpm typecheck
    
    print_info "Running tests..."
    pnpm test
    
    print_info "Building applications..."
    pnpm build
    
    print_success "Local CI completed!"
}

clean_all() {
    print_header
    print_info "Cleaning all build artifacts and caches..."
    
    # Clean Turbo cache
    rm -rf .turbo
    
    # Clean all build outputs
    pnpm clean
    
    # Clean node_modules
    rm -rf node_modules
    find . -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
    
    print_success "Everything cleaned!"
}

show_help() {
    print_header
    echo "Available commands:"
    echo "  setup           - Setup development environment"
    echo "  dev             - Start development servers"
    echo "  build           - Run optimized build"
    echo "  test            - Run all tests"
    echo "  ci              - Run CI pipeline locally"
    echo "  clean           - Clean all artifacts and caches"
    echo "  help            - Show this help"
}

# Parse command line arguments
case "${1:-help}" in
    setup)
        setup
        ;;
    dev)
        dev
        ;;
    build)
        build_optimized
        ;;
    test)
        test_all
        ;;
    ci)
        ci_local
        ;;
    clean)
        clean_all
        ;;
    help|*)
        show_help
        ;;
esac
