#!/bin/bash

# Homelab Services Management Script
# Start All Services
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
LOG_FILE="$SCRIPT_DIR/startup.log"
MAX_RETRIES=3
RETRY_DELAY=30

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
    
    # Sort services by dependency (core services first)
    local sorted_services=()
    local core_services=("homelab" "additional" "storage" "network")
    local other_services=()
    
    # Add core services first
    for core_service in "${core_services[@]}"; do
        for service in "${services[@]}"; do
            if [ "$service" = "$core_service" ]; then
                sorted_services+=("$service")
                break
            fi
        done
    done
    
    # Add remaining services
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
    
    echo "${sorted_services[@]}"
}

# Function to check for port conflicts
check_port_conflicts() {
    local service_dir="$1"
    local conflicts=()
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        return 0
    fi
    
    # Extract ports from docker-compose.yml
    local ports=$(grep -E "^\s*- \"[0-9]+:" "$service_dir/docker-compose.yml" | sed 's/.*"\([0-9]*\):.*/\1/' | sort -u)
    
    for port in $ports; do
        if [ -n "$port" ] && [ "$port" -gt 0 ]; then
            # Check if port is already in use
            if netstat -tuln 2>/dev/null | grep -q ":$port "; then
                conflicts+=("$port")
            fi
        fi
    done
    
    if [ ${#conflicts[@]} -gt 0 ]; then
        print_warning "Port conflicts detected in $(basename "$service_dir"): ${conflicts[*]}"
        return 1
    fi
    
    return 0
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
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if service is already running
is_service_running() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    
    if docker-compose -f "$service_dir/docker-compose.yml" ps --services --filter "status=running" | grep -q .; then
        return 0  # Service is running
    else
        return 1  # Service is not running
    fi
}

# Function to check service health
check_service_health() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local max_attempts=10
    local attempt=1
    
    print_status "Checking health of $service_name..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose -f "$service_dir/docker-compose.yml" ps --services --filter "status=running" | grep -q .; then
            print_success "$service_name is healthy"
            return 0
        fi
        
        print_warning "Attempt $attempt/$max_attempts: $service_name is starting..."
        sleep 10
        ((attempt++))
    done
    
    print_error "$service_name failed to start properly"
    return 1
}

# Function to start a single service
start_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local retry_count=0
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        print_warning "No docker-compose.yml found in $service_dir, skipping..."
        return 0
    fi
    
    print_status "Processing service: $service_name"
    
    # Check for port conflicts
    if ! check_port_conflicts "$service_dir"; then
        print_warning "Skipping $service_name due to port conflicts"
        return 1
    fi
    
    # Check if service is already running
    if is_service_running "$service_dir"; then
        print_success "$service_name is already running"
        return 0
    fi
    
    # Start service with retries
    while [ $retry_count -lt $MAX_RETRIES ]; do
        print_status "Starting $service_name (attempt $((retry_count + 1))/$MAX_RETRIES)..."
        
        if docker-compose -f "$service_dir/docker-compose.yml" up -d; then
            print_success "$service_name started successfully"
            
            # Wait a moment for services to initialize
            sleep 5
            
            # Check service health
            if check_service_health "$service_dir"; then
                return 0
            else
                print_warning "$service_name started but health check failed"
                return 1
            fi
        else
            print_error "Failed to start $service_name"
            ((retry_count++))
            
            if [ $retry_count -lt $MAX_RETRIES ]; then
                print_status "Retrying in $RETRY_DELAY seconds..."
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    print_error "Failed to start $service_name after $MAX_RETRIES attempts"
    return 1
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

# Function to show startup summary
show_summary() {
    print_status "Startup Summary:"
    echo "----------------------------------------"
    
    local running_count=0
    local total_count=0
    local services=($(detect_services))
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            ((total_count++))
            if is_service_running "$full_path"; then
                print_success "$service_dir: RUNNING"
                ((running_count++))
            else
                print_error "$service_dir: FAILED"
            fi
        fi
    done
    
    echo "----------------------------------------"
    print_status "Total services: $total_count"
    print_status "Running: $running_count"
    print_status "Failed: $((total_count - running_count))"
    
    if [ $running_count -eq $total_count ]; then
        print_success "All services started successfully!"
    else
        print_warning "Some services failed to start. Check logs for details."
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
    echo "  -l, --log      Show startup log"
    echo "  -f, --force    Force restart of running services"
    echo "  -q, --quiet    Quiet mode (minimal output)"
    echo "  -c, --check    Check for port conflicts only"
    echo ""
    echo "Examples:"
    echo "  $0              # Start all services"
    echo "  $0 --status     # Show current status"
    echo "  $0 --force      # Force restart all services"
    echo "  $0 --check      # Check for port conflicts"
    echo ""
}

# Function to show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo "=== Startup Log ==="
        tail -50 "$LOG_FILE"
    else
        print_warning "No log file found"
    fi
}

# Function to check for port conflicts across all services
check_all_port_conflicts() {
    print_status "Checking for port conflicts across all services..."
    
    local services=($(detect_services))
    local has_conflicts=false
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ] && [ -f "$full_path/docker-compose.yml" ]; then
            if ! check_port_conflicts "$full_path"; then
                has_conflicts=true
            fi
        fi
    done
    
    if [ "$has_conflicts" = true ]; then
        print_error "Port conflicts detected. Please resolve before starting services."
        return 1
    else
        print_success "No port conflicts detected."
        return 0
    fi
}

# Main execution
main() {
    local force_restart=false
    local show_status_only=false
    local show_logs_only=false
    local quiet_mode=false
    local check_conflicts_only=false
    
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
                force_restart=true
                shift
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            -c|--check)
                check_conflicts_only=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Initialize log file
    echo "=== Homelab Services Startup Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    if [ "$show_logs_only" = true ]; then
        show_logs
        exit 0
    fi
    
    if [ "$check_conflicts_only" = true ]; then
        check_all_port_conflicts
        exit $?
    fi
    
    if [ "$show_status_only" = true ]; then
        show_status
        exit 0
    fi
    
    log_message "Starting homelab services..."
    
    # Check Docker
    check_docker
    
    # Check for port conflicts
    if ! check_all_port_conflicts; then
        exit 1
    fi
    
    # Show initial status
    if [ "$quiet_mode" = false ]; then
        show_status
    fi
    
    # Get detected services
    local services=($(detect_services))
    
    if [ ${#services[@]} -eq 0 ]; then
        print_warning "No service directories found with docker-compose.yml files"
        exit 0
    fi
    
    log_message "Detected ${#services[@]} services: ${services[*]}"
    
    # Start services
    local failed_services=()
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ]; then
            if start_service "$full_path"; then
                log_message "Service $service_dir started successfully"
            else
                log_message "Service $service_dir failed to start"
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
        print_error "Failed services:"
        for service in "${failed_services[@]}"; do
            print_error "  - $service"
        done
        print_status "Check logs with: $0 --log"
        exit 1
    fi
    
    log_message "All services started successfully"
    print_success "Homelab services startup completed!"
}

# Run main function
main "$@" 