#!/bin/bash

# Homelab Services Management Script
# Stop All Services
# Author: Homelab Manager
# Version: 2.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="$SCRIPT_DIR"
LOG_FILE="$SCRIPT_DIR/shutdown.log"
TIMEOUT=60

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
    
    # Sort services by dependency (reverse order for shutdown)
    local sorted_services=()
    local core_services=("homelab" "additional" "storage" "network")
    local other_services=()
    
    # Add non-core services first (reverse dependency order)
    for service in "${services[@]}"; do
        local is_core=false
        for core_service in "${core_services[@]}"; do
            if [ "$service" = "$core_service" ]; then
                is_core=true
                break
            fi
        done
        
        if [ "$is_core" = false ]; then
            sorted_services+=("$service")
        fi
    done
    
    # Add core services last (reverse dependency order)
    for ((i=${#core_services[@]}-1; i>=0; i--)); do
        for service in "${services[@]}"; do
            if [ "$service" = "${core_services[$i]}" ]; then
                sorted_services+=("$service")
                break
            fi
        done
    done
    
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

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    print_status "$1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. No services to stop."
        exit 1
    fi
    print_success "Docker is running"
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

# Function to stop a single service
stop_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        print_warning "No docker-compose.yml found in $service_dir, skipping..."
        return 0
    fi
    
    print_status "Processing service: $service_name"
    
    # Check if service is running
    if ! is_service_running "$service_dir"; then
        print_success "$service_name is already stopped"
        return 0
    fi
    
    print_status "Stopping $service_name..."
    
    # Stop the service
    if docker-compose -f "$service_dir/docker-compose.yml" down --timeout $TIMEOUT; then
        print_success "$service_name stopped successfully"
        return 0
    else
        print_error "Failed to stop $service_name gracefully"
        
        # Try force stop
        print_warning "Attempting force stop for $service_name..."
        if docker-compose -f "$service_dir/docker-compose.yml" down --timeout 10 --remove-orphans; then
            print_success "$service_name force stopped"
            return 0
        else
            print_error "Failed to force stop $service_name"
            return 1
        fi
    fi
}

# Function to display service status
show_status() {
    print_status "Current service status:"
    echo "----------------------------------------"
    
    local services=($(detect_services))
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            if is_service_running "$full_path"; then
                print_success "$service_dir: RUNNING"
            else
                print_error "$service_dir: STOPPED"
            fi
        else
            print_warning "$service_dir: NO CONFIG"
        fi
    done
    echo "----------------------------------------"
}

# Function to show shutdown summary
show_summary() {
    print_status "Shutdown Summary:"
    echo "----------------------------------------"
    
    local running_count=0
    local total_count=0
    local services=($(detect_services))
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            ((total_count++))
            if is_service_running "$full_path"; then
                print_error "$service_dir: STILL RUNNING"
                ((running_count++))
            else
                print_success "$service_dir: STOPPED"
            fi
        fi
    done
    
    echo "----------------------------------------"
    print_status "Total services: $total_count"
    print_status "Stopped: $((total_count - running_count))"
    print_status "Still running: $running_count"
    
    if [ $running_count -eq 0 ]; then
        print_success "All services stopped successfully!"
    else
        print_warning "Some services are still running. You may need to force stop them."
    fi
}

# Function to show help
show_help() {
    echo "Homelab Services Management Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --status   Show current service status"
    echo "  -l, --log      Show shutdown log"
    echo "  -f, --force    Force stop all services (kill containers)"
    echo "  -q, --quiet    Quiet mode (minimal output)"
    echo "  -t, --timeout  Set timeout for graceful shutdown (default: 60s)"
    echo ""
    echo "Examples:"
    echo "  $0              # Stop all services gracefully"
    echo "  $0 --status     # Show current status"
    echo "  $0 --force      # Force stop all services"
    echo "  $0 --timeout 30 # Stop with 30 second timeout"
    echo ""
}

# Function to show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo "=== Shutdown Log ==="
        tail -50 "$LOG_FILE"
    else
        print_warning "No log file found"
    fi
}

# Function to force stop all containers
force_stop_all() {
    print_warning "Force stopping all Docker containers..."
    
    # Stop all running containers
    local running_containers=$(docker ps -q)
    
    if [ -n "$running_containers" ]; then
        if docker stop $running_containers; then
            print_success "All containers force stopped"
        else
            print_error "Failed to force stop some containers"
            return 1
        fi
    else
        print_success "No running containers found"
    fi
    
    # Remove stopped containers
    local stopped_containers=$(docker ps -aq)
    
    if [ -n "$stopped_containers" ]; then
        if docker rm $stopped_containers; then
            print_success "All stopped containers removed"
        else
            print_warning "Failed to remove some stopped containers"
        fi
    fi
}

# Main execution
main() {
    local force_stop=false
    local show_status_only=false
    local show_logs_only=false
    local quiet_mode=false
    local custom_timeout=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -s|--status)
                show_status_only=true
                shift
                ;;
            -l|--log)
                show_logs_only=true
                shift
                ;;
            -f|--force)
                force_stop=true
                shift
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            -t|--timeout)
                custom_timeout="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Set custom timeout if provided
    if [ -n "$custom_timeout" ]; then
        if [[ "$custom_timeout" =~ ^[0-9]+$ ]] && [ "$custom_timeout" -gt 0 ]; then
            TIMEOUT="$custom_timeout"
        else
            print_error "Invalid timeout value: $custom_timeout"
            exit 1
        fi
    fi
    
    # Initialize log file
    echo "=== Homelab Services Shutdown Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    if [ "$show_logs_only" = true ]; then
        show_logs
        exit 0
    fi
    
    if [ "$show_status_only" = true ]; then
        show_status
        exit 0
    fi
    
    log_message "Stopping homelab services..."
    
    # Check Docker
    check_docker
    
    # Show initial status
    if [ "$quiet_mode" = false ]; then
        show_status
    fi
    
    # Handle force stop
    if [ "$force_stop" = true ]; then
        force_stop_all
        exit 0
    fi
    
    # Get detected services
    local services=($(detect_services))
    
    if [ ${#services[@]} -eq 0 ]; then
        print_warning "No service directories found with docker-compose.yml files"
        exit 0
    fi
    
    log_message "Detected ${#services[@]} services: ${services[*]}"
    
    # Stop services
    local failed_services=()
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ]; then
            if stop_service "$full_path"; then
                log_message "Service $service_dir stopped successfully"
            else
                log_message "Service $service_dir failed to stop"
                failed_services+=("$service_dir")
            fi
        else
            log_message "Service directory $service_dir not found, skipping..."
        fi
    done
    
    # Show final status
    if [ "$quiet_mode" = false ]; then
        show_summary
    fi
    
    # Show failed services if any
    if [ ${#failed_services[@]} -gt 0 ]; then
        print_error "Failed to stop services:"
        for service in "${failed_services[@]}"; do
            print_error "  - $service"
        done
        print_status "Use --force to force stop all containers"
        print_status "Check logs with: $0 --log"
        exit 1
    fi
    
    log_message "All services stopped successfully"
    print_success "Homelab services shutdown completed!"
}

# Run main function
main "$@" 