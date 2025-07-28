#!/bin/bash

# NMC Quick Commands - Convenient aliases for common tasks
# Usage: source ./nmc.sh (to set up aliases) or ./nmc.sh [command]

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOCKER_MANAGER="${SCRIPT_DIR}/docker-manager.sh"
readonly DEV_HELPER="${SCRIPT_DIR}/dev-helper.sh"

# Colors
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Make scripts executable
chmod +x "${DOCKER_MANAGER}" "${DEV_HELPER}" 2>/dev/null || true

# Function to create aliases
setup_aliases() {
    echo -e "${BLUE}Setting up NMC aliases...${NC}"
    
    # Docker management aliases
    alias nmc-start="${DOCKER_MANAGER} start"
    alias nmc-stop="${DOCKER_MANAGER} stop"
    alias nmc-restart="${DOCKER_MANAGER} restart"
    alias nmc-build="${DOCKER_MANAGER} build"
    alias nmc-rebuild="${DOCKER_MANAGER} rebuild"
    alias nmc-logs="${DOCKER_MANAGER} logs"
    alias nmc-status="${DOCKER_MANAGER} status"
    alias nmc-health="${DOCKER_MANAGER} health"
    alias nmc-clean="${DOCKER_MANAGER} clean"
    alias nmc-deploy="${DOCKER_MANAGER} deploy"
    
    # Build and maintenance aliases
    alias nmc-install="${DEV_HELPER} install"
    alias nmc-lint="${DEV_HELPER} lint"
    alias nmc-test="${DEV_HELPER} test"
    
    # Combined aliases for common workflows
    alias nmc-fresh="${DEV_HELPER} clean && ${DEV_HELPER} install && ${DOCKER_MANAGER} build --force"
    alias nmc-quick-start="${DOCKER_MANAGER} start && ${DOCKER_MANAGER} health"
    alias nmc-full-restart="${DOCKER_MANAGER} stop && ${DOCKER_MANAGER} clean && ${DOCKER_MANAGER} start"
    
    echo -e "${GREEN}✅ NMC aliases set up successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Available commands:${NC}"
    echo "  Docker Management:"
    echo "    nmc-start, nmc-stop, nmc-restart"
    echo "    nmc-build, nmc-rebuild, nmc-deploy"
    echo "    nmc-logs, nmc-status, nmc-health, nmc-clean"
    echo ""
    echo "  Build & Maintenance:"
    echo "    nmc-install, nmc-lint, nmc-test"
    echo ""
    echo "  Quick Actions:"
    echo "    nmc-fresh (clean + install + rebuild)"
    echo "    nmc-quick-start (start + health check)"
    echo "    nmc-full-restart (stop + clean + start)"
    echo ""
}

# Function to show quick help
quick_help() {
    echo "NMC Quick Commands"
    echo ""
    echo "To set up aliases in your current shell:"
    echo "  source ./scripts/nmc.sh"
    echo ""
    echo "Or run commands directly:"
    echo "  ./scripts/nmc.sh [command]"
    echo ""
    echo "Available direct commands:"
    echo "  help          Show this help"
    echo "  aliases       Set up aliases"
    echo "  status        Show current status"
    echo "  quick-start   Start all services with health check"
    echo "  full-restart  Complete restart cycle"
    echo "  fresh         Clean installation and rebuild"
    echo ""
    echo "For detailed help on docker operations:"
    echo "  ./scripts/docker-manager.sh help"
    echo ""
    echo "For detailed help on development:"
    echo "  ./scripts/dev-helper.sh help"
}

# Handle direct command execution
handle_command() {
    case "${1:-help}" in
        "help"|"--help"|"-h")
            quick_help
            ;;
        "aliases")
            setup_aliases
            ;;
        "status")
            "${DOCKER_MANAGER}" status
            ;;
        "quick-start")
            "${DOCKER_MANAGER}" start && "${DOCKER_MANAGER}" health
            ;;
        "full-restart")
            "${DOCKER_MANAGER}" stop && "${DOCKER_MANAGER}" clean && "${DOCKER_MANAGER}" start
            ;;
        "fresh")
            "${DEV_HELPER}" clean && "${DEV_HELPER}" install && "${DOCKER_MANAGER}" build --force
            ;;
        *)
            echo "Unknown command: ${1}"
            quick_help
            exit 1
            ;;
    esac
}

# Main execution logic
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed directly
    handle_command "$@"
else
    # Script is being sourced
    setup_aliases
fi
