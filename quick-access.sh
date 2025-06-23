#!/bin/bash

# Homelab Services Management Script
# Quick Access and Management
# Author: Homelab Manager
# Version: 2.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="$SCRIPT_DIR"
LOG_FILE="$SCRIPT_DIR/quick-access.log"

# Function to automatically detect service directories
detect_services() {
    local services=()
    
    # Find all directories that contain docker-compose.yml files
    for dir in "$SERVICES_DIR"/*; do
        if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
            local service_name=$(basename "$dir")
            services+=("$service_name")
        fi
    done
    
    # Sort services alphabetically
    IFS=$'\n' sorted_services=($(sort <<<"${services[*]}"))
    unset IFS
    
    echo "${sorted_services[@]}"
}

# Function to print colored output
print_status() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

print_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

print_info() {
    echo -e "${CYAN}$1${NC}"
}

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    print_status "$1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        return 1
    fi
    return 0
}

# Function to check if service is running
is_service_running() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    
    if docker-compose -f "$service_dir/docker-compose.yml" ps --services --filter "status=running" | grep -q .; then
        return 0  # Service is running
    else
        return 1  # Service is not running
    fi
}

# Function to get service ports
get_service_ports() {
    local service_dir="$1"
    local ports=()
    
    if [ -f "$service_dir/docker-compose.yml" ]; then
        # Extract ports from docker-compose.yml
        local port_lines=$(grep -E "^\s*- \"[0-9]+:" "$service_dir/docker-compose.yml" | sed 's/.*"\([0-9]*\):.*/\1/' | sort -u)
        
        for port in $port_lines; do
            if [ -n "$port" ] && [ "$port" -gt 0 ]; then
                ports+=("$port")
            fi
        done
    fi
    
    echo "${ports[@]}"
}

# Function to get service URLs
get_service_urls() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local urls=()
    
    # Get ports for this service
    local ports=($(get_service_ports "$service_dir"))
    
    # Common service URLs
    case "$service_name" in
        "homelab")
            urls+=("http://localhost:8080 - Traefik Dashboard")
            urls+=("http://localhost:8081 - Portainer")
            ;;
        "additional")
            urls+=("http://localhost:4000 - Navidrome")
            urls+=("http://localhost:4001 - Immich")
            urls+=("http://localhost:4002 - FreshRSS")
            ;;
        "jellyfin")
            urls+=("http://localhost:8096 - Jellyfin")
            ;;
        "homeassistant")
            urls+=("http://localhost:8123 - Home Assistant")
            ;;
        "pihole")
            urls+=("http://localhost:8082 - Pi-hole Admin")
            ;;
        "wordpress")
            urls+=("http://localhost:8000 - WordPress")
            ;;
        "n8n")
            urls+=("http://localhost:5678 - n8n")
            ;;
        "puppeteer")
            urls+=("http://localhost:3000 - Puppeteer")
            ;;
        "glances")
            urls+=("http://localhost:61208 - Glances")
            ;;
        "storage")
            urls+=("http://localhost:8080 - Nextcloud")
            urls+=("http://localhost:8083 - File Browser")
            urls+=("http://localhost:8200 - Duplicati")
            ;;
        "network")
            urls+=("http://localhost:8082 - Pi-hole")
            urls+=("http://localhost:3001 - Uptime Kuma")
            urls+=("http://localhost:8086 - Zabbix Web")
            ;;
        "urlwatch")
            urls+=("http://localhost:8080 - urlwatch")
            ;;
        *)
            # Generic URLs based on ports
            for port in "${ports[@]}"; do
                urls+=("http://localhost:$port - $service_name")
            done
            ;;
    esac
    
    echo "${urls[@]}"
}

# Function to display service status
show_service_status() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local full_path="$SERVICES_DIR/$service_dir"
    
    if [ ! -f "$full_path/docker-compose.yml" ]; then
        print_warning "$service_name: NO CONFIG"
        return
    fi
    
    if is_service_running "$full_path"; then
        print_success "$service_name: RUNNING"
        
        # Show URLs
        local urls=($(get_service_urls "$full_path"))
        for url in "${urls[@]}"; do
            print_info "  $url"
        done
    else
        print_error "$service_name: STOPPED"
    fi
}

# Function to show all services status
show_all_status() {
    print_status "Current service status:"
    echo "========================================"
    
    local services=($(detect_services))
    local running_count=0
    local total_count=0
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            ((total_count++))
            if is_service_running "$full_path"; then
                ((running_count++))
            fi
        fi
        
        show_service_status "$full_path"
        echo ""
    done
    
    echo "========================================"
    print_status "Summary: $running_count/$total_count services running"
}

# Function to start a specific service
start_service() {
    local service_name="$1"
    local service_dir="$SERVICES_DIR/$service_name"
    
    if [ ! -d "$service_dir" ]; then
        print_error "Service '$service_name' not found"
        return 1
    fi
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        print_error "No docker-compose.yml found for '$service_name'"
        return 1
    fi
    
    print_status "Starting $service_name..."
    
    if docker-compose -f "$service_dir/docker-compose.yml" up -d; then
        print_success "$service_name started successfully"
        
        # Wait a moment and show URLs
        sleep 3
        local urls=($(get_service_urls "$service_dir"))
        if [ ${#urls[@]} -gt 0 ]; then
            print_info "Available at:"
            for url in "${urls[@]}"; do
                print_info "  $url"
            done
        fi
        
        return 0
    else
        print_error "Failed to start $service_name"
        return 1
    fi
}

# Function to stop a specific service
stop_service() {
    local service_name="$1"
    local service_dir="$SERVICES_DIR/$service_name"
    
    if [ ! -d "$service_dir" ]; then
        print_error "Service '$service_name' not found"
        return 1
    fi
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        print_error "No docker-compose.yml found for '$service_name'"
        return 1
    fi
    
    print_status "Stopping $service_name..."
    
    if docker-compose -f "$service_dir/docker-compose.yml" down; then
        print_success "$service_name stopped successfully"
        return 0
    else
        print_error "Failed to stop $service_name"
        return 1
    fi
}

# Function to restart a specific service
restart_service() {
    local service_name="$1"
    
    print_status "Restarting $service_name..."
    
    if stop_service "$service_name" && start_service "$service_name"; then
        print_success "$service_name restarted successfully"
        return 0
    else
        print_error "Failed to restart $service_name"
        return 1
    fi
}

# Function to show service logs
show_service_logs() {
    local service_name="$1"
    local service_dir="$SERVICES_DIR/$service_name"
    local lines="${2:-50}"
    
    if [ ! -d "$service_dir" ]; then
        print_error "Service '$service_name' not found"
        return 1
    fi
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        print_error "No docker-compose.yml found for '$service_name'"
        return 1
    fi
    
    print_status "Showing logs for $service_name (last $lines lines)..."
    echo "----------------------------------------"
    
    if docker-compose -f "$service_dir/docker-compose.yml" logs --tail="$lines"; then
        print_success "Logs displayed for $service_name"
    else
        print_error "Failed to show logs for $service_name"
        return 1
    fi
}

# Function to open service in browser
open_service() {
    local service_name="$1"
    local service_dir="$SERVICES_DIR/$service_name"
    
    if [ ! -d "$service_dir" ]; then
        print_error "Service '$service_name' not found"
        return 1
    fi
    
    # Get the first URL for this service
    local urls=($(get_service_urls "$service_dir"))
    
    if [ ${#urls[@]} -eq 0 ]; then
        print_error "No URLs found for $service_name"
        return 1
    fi
    
    # Extract the URL from the first entry
    local url=$(echo "${urls[0]}" | awk '{print $1}')
    
    print_status "Opening $service_name at $url..."
    
    # Try to open in browser
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url"
    elif command -v open >/dev/null 2>&1; then
        open "$url"
    elif command -v start >/dev/null 2>&1; then
        start "$url"
    else
        print_warning "Could not open browser automatically. Please visit: $url"
        return 1
    fi
    
    print_success "Opened $service_name in browser"
    return 0
}

# Function to show service information
show_service_info() {
    local service_name="$1"
    local service_dir="$SERVICES_DIR/$service_name"
    
    if [ ! -d "$service_dir" ]; then
        print_error "Service '$service_name' not found"
        return 1
    fi
    
    print_status "Information for $service_name:"
    echo "----------------------------------------"
    
    # Check if running
    if is_service_running "$service_dir"; then
        print_success "Status: RUNNING"
    else
        print_error "Status: STOPPED"
    fi
    
    # Show ports
    local ports=($(get_service_ports "$service_dir"))
    if [ ${#ports[@]} -gt 0 ]; then
        print_info "Ports: ${ports[*]}"
    fi
    
    # Show URLs
    local urls=($(get_service_urls "$service_dir"))
    if [ ${#urls[@]} -gt 0 ]; then
        print_info "URLs:"
        for url in "${urls[@]}"; do
            print_info "  $url"
        done
    fi
    
    # Show docker-compose.yml location
    if [ -f "$service_dir/docker-compose.yml" ]; then
        print_info "Config: $service_dir/docker-compose.yml"
    fi
    
    # Show README if exists
    if [ -f "$service_dir/README.md" ]; then
        print_info "Documentation: $service_dir/README.md"
    fi
}

# Function to show interactive menu
show_menu() {
    echo ""
    echo "========================================"
    echo "        Homelab Quick Access Menu"
    echo "========================================"
    echo ""
    
    local services=($(detect_services))
    
    echo "Available services:"
    for i in "${!services[@]}"; do
        local service_name="${services[$i]}"
        local full_path="$SERVICES_DIR/$service_name"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            if is_service_running "$full_path"; then
                echo -e "  ${GREEN}$((i+1)). $service_name (RUNNING)${NC}"
            else
                echo -e "  ${RED}$((i+1)). $service_name (STOPPED)${NC}"
            fi
        else
            echo -e "  ${YELLOW}$((i+1)). $service_name (NO CONFIG)${NC}"
        fi
    done
    
    echo ""
    echo "Commands:"
    echo "  start <service>     - Start a specific service"
    echo "  stop <service>      - Stop a specific service"
    echo "  restart <service>   - Restart a specific service"
    echo "  logs <service>      - Show service logs"
    echo "  open <service>      - Open service in browser"
    echo "  info <service>      - Show service information"
    echo "  status              - Show all services status"
    echo "  menu                - Show this menu"
    echo "  help                - Show help"
    echo "  quit                - Exit"
    echo ""
}

# Function to show help
show_help() {
    echo "Homelab Services Quick Access Script"
    echo ""
    echo "Usage: $0 [OPTIONS] [COMMAND] [SERVICE]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -i, --interactive  Start interactive mode"
    echo "  -s, --status   Show all services status"
    echo ""
    echo "Commands:"
    echo "  start <service>     - Start a specific service"
    echo "  stop <service>      - Stop a specific service"
    echo "  restart <service>   - Restart a specific service"
    echo "  logs <service>      - Show service logs"
    echo "  open <service>      - Open service in browser"
    echo "  info <service>      - Show service information"
    echo "  status              - Show all services status"
    echo ""
    echo "Examples:"
    echo "  $0 status                    # Show all services status"
    echo "  $0 start jellyfin            # Start Jellyfin"
    echo "  $0 open homeassistant        # Open Home Assistant in browser"
    echo "  $0 logs pihole               # Show Pi-hole logs"
    echo "  $0 --interactive             # Start interactive mode"
    echo ""
}

# Function to run interactive mode
run_interactive() {
    print_status "Starting interactive mode..."
    
    if ! check_docker; then
        exit 1
    fi
    
    show_menu
    
    while true; do
        echo -n "homelab> "
        read -r input
        
        if [ -z "$input" ]; then
            continue
        fi
        
        # Parse input
        read -ra args <<< "$input"
        local command="${args[0]}"
        local service="${args[1]}"
        
        case "$command" in
            "start")
                if [ -n "$service" ]; then
                    start_service "$service"
                else
                    print_error "Please specify a service to start"
                fi
                ;;
            "stop")
                if [ -n "$service" ]; then
                    stop_service "$service"
                else
                    print_error "Please specify a service to stop"
                fi
                ;;
            "restart")
                if [ -n "$service" ]; then
                    restart_service "$service"
                else
                    print_error "Please specify a service to restart"
                fi
                ;;
            "logs")
                if [ -n "$service" ]; then
                    show_service_logs "$service"
                else
                    print_error "Please specify a service for logs"
                fi
                ;;
            "open")
                if [ -n "$service" ]; then
                    open_service "$service"
                else
                    print_error "Please specify a service to open"
                fi
                ;;
            "info")
                if [ -n "$service" ]; then
                    show_service_info "$service"
                else
                    print_error "Please specify a service for info"
                fi
                ;;
            "status")
                show_all_status
                ;;
            "menu")
                show_menu
                ;;
            "help")
                show_help
                ;;
            "quit"|"exit")
                print_status "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Unknown command: $command"
                print_info "Type 'help' for available commands"
                ;;
        esac
        
        echo ""
    done
}

# Main execution
main() {
    local interactive_mode=false
    local show_status_only=false
    local command=""
    local service=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -i|--interactive)
                interactive_mode=true
                shift
                ;;
            -s|--status)
                show_status_only=true
                shift
                ;;
            start|stop|restart|logs|open|info)
                command="$1"
                service="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Initialize log file
    echo "=== Homelab Quick Access Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    # Check Docker
    if ! check_docker; then
        exit 1
    fi
    
    # Handle different modes
    if [ "$interactive_mode" = true ]; then
        run_interactive
        exit 0
    fi
    
    if [ "$show_status_only" = true ]; then
        show_all_status
        exit 0
    fi
    
    if [ -n "$command" ]; then
        case "$command" in
            "start")
                if [ -n "$service" ]; then
                    start_service "$service"
                else
                    print_error "Please specify a service to start"
                    exit 1
                fi
                ;;
            "stop")
                if [ -n "$service" ]; then
                    stop_service "$service"
                else
                    print_error "Please specify a service to stop"
                    exit 1
                fi
                ;;
            "restart")
                if [ -n "$service" ]; then
                    restart_service "$service"
                else
                    print_error "Please specify a service to restart"
                    exit 1
                fi
                ;;
            "logs")
                if [ -n "$service" ]; then
                    show_service_logs "$service"
                else
                    print_error "Please specify a service for logs"
                    exit 1
                fi
                ;;
            "open")
                if [ -n "$service" ]; then
                    open_service "$service"
                else
                    print_error "Please specify a service to open"
                    exit 1
                fi
                ;;
            "info")
                if [ -n "$service" ]; then
                    show_service_info "$service"
                else
                    print_error "Please specify a service for info"
                    exit 1
                fi
                ;;
            *)
                print_error "Unknown command: $command"
                show_help
                exit 1
                ;;
        esac
        exit 0
    fi
    
    # Default behavior: show status
    show_all_status
}

# Run main function
main "$@" 