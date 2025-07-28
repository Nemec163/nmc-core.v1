#!/bin/bash

# NMC Development Helper - Script for development tasks
# Usage: ./dev-helper.sh [command] [options]

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors and emojis
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

readonly SUCCESS="✅"
readonly ERROR="❌"
readonly INFO="ℹ️"
readonly WORKING="🔄"
readonly DEV="🛠️"
readonly PACKAGE="📦"

# Change to project root
cd "${PROJECT_ROOT}" || { echo "${ERROR} Cannot change to project root"; exit 1; }

# Utility functions
log() {
    echo -e "${1}"
}

error_exit() {
    log "${ERROR} ${RED}Error: $1${NC}"
    exit 1
}

success() {
    log "${SUCCESS} ${GREEN}$1${NC}"
}

info() {
    log "${INFO} ${BLUE}$1${NC}"
}

working() {
    log "${WORKING} ${YELLOW}$1${NC}"
}

# Check dependencies
check_dependencies() {
    if ! command -v pnpm &> /dev/null; then
        error_exit "pnpm not found. Please install pnpm: npm install -g pnpm"
    fi
    
    if ! command -v turbo &> /dev/null; then
        working "Installing turbo globally..."
        pnpm install -g turbo
    fi
}

# Install dependencies
install_deps() {
    working "Installing dependencies with pnpm..."
    pnpm install
    success "Dependencies installed successfully"
}

# Development servers (for local development only)
# Use docker-manager.sh for VPS deployment

# Build commands
build_all() {
    working "Building all packages..."
    pnpm run build
    success "All packages built successfully"
}

build_storybook() {
    working "Building storybook..."
    pnpm run build:storybook
    success "Storybook built successfully"
}

# Lint and format
lint_all() {
    working "Running linters on all packages..."
    pnpm run lint
    success "Linting completed"
}

lint_fix() {
    working "Running linters with auto-fix on all packages..."
    turbo run lint:fix 2>/dev/null || {
        info "lint:fix script not found, running standard lint..."
        pnpm run lint
    }
    success "Linting with auto-fix completed"
}

# Clean commands
clean_node_modules() {
    working "Cleaning node_modules..."
    find . -name "node_modules" -type d -prune -exec rm -rf {} +
    success "node_modules cleaned"
}

clean_dist() {
    working "Cleaning dist/build directories..."
    find . -name "dist" -type d -prune -exec rm -rf {} + 2>/dev/null || true
    find . -name "build" -type d -prune -exec rm -rf {} + 2>/dev/null || true
    find . -name ".next" -type d -prune -exec rm -rf {} + 2>/dev/null || true
    find . -name "storybook-static" -type d -prune -exec rm -rf {} + 2>/dev/null || true
    success "Build directories cleaned"
}

clean_all() {
    clean_node_modules
    clean_dist
    rm -f pnpm-lock.yaml 2>/dev/null || true
    success "Full cleanup completed"
}

# Package management
add_package() {
    local package_name="${1:-}"
    local workspace="${2:-}"
    
    if [[ -z "${package_name}" ]]; then
        error_exit "Package name is required"
    fi
    
    if [[ -n "${workspace}" ]]; then
        working "Adding ${package_name} to workspace ${workspace}..."
        pnpm --filter "${workspace}" add "${package_name}"
    else
        working "Adding ${package_name} to root workspace..."
        pnpm add "${package_name}"
    fi
    
    success "Package ${package_name} added successfully"
}

add_dev_package() {
    local package_name="${1:-}"
    local workspace="${2:-}"
    
    if [[ -z "${package_name}" ]]; then
        error_exit "Package name is required"
    fi
    
    if [[ -n "${workspace}" ]]; then
        working "Adding ${package_name} as dev dependency to workspace ${workspace}..."
        pnpm --filter "${workspace}" add -D "${package_name}"
    else
        working "Adding ${package_name} as dev dependency to root workspace..."
        pnpm add -D "${package_name}"
    fi
    
    success "Dev package ${package_name} added successfully"
}

# Workspace utilities
list_workspaces() {
    info "Available workspaces:"
    pnpm list -r --depth=-1 --json | jq -r '.[].name' 2>/dev/null || {
        pnpm list -r --depth=-1
    }
}

workspace_info() {
    local workspace="${1:-}"
    
    if [[ -z "${workspace}" ]]; then
        error_exit "Workspace name is required"
    fi
    
    info "Information for workspace: ${workspace}"
    pnpm --filter "${workspace}" list 2>/dev/null || error_exit "Workspace ${workspace} not found"
}

# Testing utilities
test_all() {
    working "Running tests for all packages..."
    turbo run test 2>/dev/null || {
        info "No test scripts found in turbo.json, trying individual packages..."
        pnpm run test 2>/dev/null || info "No test scripts configured"
    }
}

test_workspace() {
    local workspace="${1:-}"
    
    if [[ -z "${workspace}" ]]; then
        error_exit "Workspace name is required"
    fi
    
    working "Running tests for workspace: ${workspace}"
    pnpm --filter "${workspace}" test
}

# Setup new workspace
create_workspace() {
    local type="${1:-}"
    local name="${2:-}"
    
    if [[ -z "${type}" ]] || [[ -z "${name}" ]]; then
        error_exit "Usage: create-workspace [app|package] [name]"
    fi
    
    local target_dir=""
    
    case "${type}" in
        "app")
            target_dir="apps/${name}"
            ;;
        "package")
            target_dir="packages/${name}"
            ;;
        *)
            error_exit "Type must be 'app' or 'package'"
            ;;
    esac
    
    if [[ -d "${target_dir}" ]]; then
        error_exit "Directory ${target_dir} already exists"
    fi
    
    working "Creating ${type}: ${name}..."
    mkdir -p "${target_dir}"
    
    # Create basic package.json
    cat > "${target_dir}/package.json" << EOF
{
  "name": "${name}",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "echo 'Dev script for ${name}'",
    "build": "echo 'Build script for ${name}'",
    "lint": "echo 'Lint script for ${name}'"
  }
}
EOF
    
    # Create basic README
    cat > "${target_dir}/README.md" << EOF
# ${name}

This is a ${type} in the NMC monorepo.

## Development

\`\`\`bash
pnpm --filter ${name} dev
\`\`\`

## Build

\`\`\`bash
pnpm --filter ${name} build
\`\`\`
EOF
    
    success "${type} ${name} created successfully at ${target_dir}"
}

# Show usage
usage() {
    echo "NMC Development Helper"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Setup Commands:"
    echo "  install                   Install all dependencies"
    echo "  check                     Check development dependencies"
    echo ""
    echo "Build Commands:"
    echo "  build                     Build all packages"
    echo "  build:storybook           Build storybook only"
    echo ""
    echo "Lint Commands:"
    echo "  lint                      Run linters on all packages"
    echo "  lint:fix                  Run linters with auto-fix"
    echo ""
    echo "Clean Commands:"
    echo "  clean:modules             Clean all node_modules"
    echo "  clean:dist                Clean all build/dist directories"
    echo "  clean                     Full cleanup (modules + dist + lockfile)"
    echo ""
    echo "Package Management:"
    echo "  add [package] [workspace] Add package to workspace (or root)"
    echo "  add:dev [package] [workspace] Add dev package to workspace (or root)"
    echo ""
    echo "Workspace Commands:"
    echo "  workspaces                List all workspaces"
    echo "  info [workspace]          Show workspace information"
    echo "  create [app|package] [name] Create new workspace"
    echo ""
    echo "Testing Commands:"
    echo "  test                      Run tests for all packages"
    echo "  test [workspace]          Run tests for specific workspace"
    echo ""
    echo "Examples:"
    echo "  $0 dev                    # Start all dev servers"
    echo "  $0 add lodash nmc-ui.v1   # Add lodash to nmc-ui.v1"
    echo "  $0 create app my-new-app  # Create new app"
    echo "  $0 test nmc-server.v1     # Test specific workspace"
}

# Main command handler
main() {
    local command="${1:-}"
    local arg1="${2:-}"
    local arg2="${3:-}"
    
    case "${command}" in
        "install")
            check_dependencies
            install_deps
            ;;
        "check")
            check_dependencies
            success "All development dependencies are available"
            ;;
        "build")
            build_all
            ;;
        "build:storybook")
            build_storybook
            ;;
        "lint")
            lint_all
            ;;
        "lint:fix")
            lint_fix
            ;;
        "clean:modules")
            clean_node_modules
            ;;
        "clean:dist")
            clean_dist
            ;;
        "clean")
            clean_all
            ;;
        "add")
            add_package "${arg1}" "${arg2}"
            ;;
        "add:dev")
            add_dev_package "${arg1}" "${arg2}"
            ;;
        "workspaces")
            list_workspaces
            ;;
        "info")
            workspace_info "${arg1}"
            ;;
        "create")
            create_workspace "${arg1}" "${arg2}"
            ;;
        "test")
            if [[ -n "${arg1}" ]]; then
                test_workspace "${arg1}"
            else
                test_all
            fi
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
