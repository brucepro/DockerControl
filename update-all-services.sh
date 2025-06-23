#!/bin/bash

# Homelab Services Management Script
# Update All Services
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
LOG_FILE="$SCRIPT_DIR/update.log"
BACKUP_DIR="$SCRIPT_DIR/backups"
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

# Function to create backup
create_backup() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local backup_timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="$BACKUP_DIR/${service_name}_${backup_timestamp}"
    
    print_status "Creating backup for $service_name..."
    
    # Create backup directory
    mkdir -p "$backup_path"
    
    # Copy docker-compose.yml
    if [ -f "$service_dir/docker-compose.yml" ]; then
        cp "$service_dir/docker-compose.yml" "$backup_path/"
    fi
    
    # Copy any .env files
    if [ -f "$service_dir/.env" ]; then
        cp "$service_dir/.env" "$backup_path/"
    fi
    
    # Copy any config directories
    for config_dir in "$service_dir"/*; do
        if [ -d "$config_dir" ] && [ "$(basename "$config_dir")" != "data" ] && [ "$(basename "$config_dir")" != "logs" ]; then
            cp -r "$config_dir" "$backup_path/"
        fi
    done
    
    print_success "Backup created: $backup_path"
    return 0
}

# Function to check for updates
check_for_updates() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    
    print_status "Checking for updates in $service_name..."
    
    # Pull latest images
    if docker-compose -f "$service_dir/docker-compose.yml" pull --quiet; then
        print_success "$service_name images updated"
        return 0
    else
        print_warning "$service_name no updates available or pull failed"
        return 1
    fi
}

# Function to update a single service
update_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local retry_count=0
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        print_warning "No docker-compose.yml found in $service_dir, skipping..."
        return 0
    fi
    
    print_status "Processing service: $service_name"
    
    # Check if service is running
    local was_running=false
    if is_service_running "$service_dir"; then
        was_running=true
        print_status "$service_name is currently running"
    else
        print_status "$service_name is not running"
    fi
    
    # Create backup before update
    if ! create_backup "$service_dir"; then
        print_error "Failed to create backup for $service_name, skipping update"
        return 1
    fi
    
    # Check for updates
    if ! check_for_updates "$service_dir"; then
        print_warning "No updates available for $service_name"
        return 0
    fi
    
    # Stop service if running
    if [ "$was_running" = true ]; then
        print_status "Stopping $service_name for update..."
        if ! docker-compose -f "$service_dir/docker-compose.yml" down; then
            print_error "Failed to stop $service_name"
            return 1
        fi
    fi
    
    # Update service with retries
    while [ $retry_count -lt $MAX_RETRIES ]; do
        print_status "Updating $service_name (attempt $((retry_count + 1))/$MAX_RETRIES)..."
        
        # Remove old containers and images
        if docker-compose -f "$service_dir/docker-compose.yml" down --rmi all --volumes --remove-orphans; then
            print_success "$service_name old containers and images removed"
        else
            print_warning "Failed to remove old containers for $service_name"
        fi
        
        # Start service with new images
        if docker-compose -f "$service_dir/docker-compose.yml" up -d; then
            print_success "$service_name updated and started successfully"
            
            # Wait a moment for services to initialize
            sleep 10
            
            # Check if service is running
            if is_service_running "$service_dir"; then
                print_success "$service_name is running after update"
                return 0
            else
                print_warning "$service_name started but not running after update"
                return 1
            fi
        else
            print_error "Failed to update $service_name"
            ((retry_count++))
            
            if [ $retry_count -lt $MAX_RETRIES ]; then
                print_status "Retrying in $RETRY_DELAY seconds..."
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    print_error "Failed to update $service_name after $MAX_RETRIES attempts"
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

# Function to show update summary
show_summary() {
    print_status "Update Summary:"
    echo "----------------------------------------"
    
    local updated_count=0
    local total_count=0
    local services=($(detect_services))
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            ((total_count++))
            if is_service_running "$full_path"; then
                print_success "$service_dir: UPDATED & RUNNING"
                ((updated_count++))
            else
                print_error "$service_dir: UPDATE FAILED"
            fi
        fi
    done
    
    echo "----------------------------------------"
    print_status "Total services: $total_count"
    print_status "Updated: $updated_count"
    print_status "Failed: $((total_count - updated_count))"
    
    if [ $updated_count -eq $total_count ]; then
        print_success "All services updated successfully!"
    else
        print_warning "Some services failed to update. Check logs for details."
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
    echo "  -l, --log      Show update log"
    echo "  -b, --backup   Create backups only (no update)"
    echo "  -c, --check    Check for updates only (no update)"
    echo "  -f, --force    Force update (ignore running state)"
    echo "  -q, --quiet    Quiet mode (minimal output)"
    echo "  -r, --retries  Set number of retry attempts (default: 3)"
    echo ""
    echo "Examples:"
    echo "  $0              # Update all services"
    echo "  $0 --status     # Show current status"
    echo "  $0 --backup     # Create backups only"
    echo "  $0 --check      # Check for updates only"
    echo "  $0 --force      # Force update all services"
    echo "  $0 --retries 5  # Update with 5 retry attempts"
    echo ""
}

# Function to show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo "=== Update Log ==="
        tail -50 "$LOG_FILE"
    else
        print_warning "No log file found"
    fi
}

# Function to create backups only
create_backups_only() {
    print_status "Creating backups for all services..."
    
    local services=($(detect_services))
    local backup_count=0
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ] && [ -f "$full_path/docker-compose.yml" ]; then
            if create_backup "$full_path"; then
                ((backup_count++))
            fi
        fi
    done
    
    print_success "Created backups for $backup_count services"
}

# Function to check for updates only
check_updates_only() {
    print_status "Checking for updates in all services..."
    
    local services=($(detect_services))
    local update_count=0
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ] && [ -f "$full_path/docker-compose.yml" ]; then
            if check_for_updates "$full_path"; then
                ((update_count++))
            fi
        fi
    done
    
    print_success "Found updates for $update_count services"
}

# Function to cleanup old backups
cleanup_backups() {
    local max_backups=5
    print_status "Cleaning up old backups (keeping $max_backups per service)..."
    
    if [ ! -d "$BACKUP_DIR" ]; then
        return 0
    fi
    
    # Get unique service names from backup directories
    local services=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "*_*" | sed 's/.*\///' | sed 's/_[0-9]*_[0-9]*$//' | sort -u)
    
    for service in $services; do
        # Get all backups for this service, sorted by timestamp (newest first)
        local backups=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "${service}_*" | sort -r)
        local count=0
        
        for backup in $backups; do
            ((count++))
            if [ $count -gt $max_backups ]; then
                print_status "Removing old backup: $(basename "$backup")"
                rm -rf "$backup"
            fi
        done
    done
    
    print_success "Backup cleanup completed"
}

# Main execution
main() {
    local backup_only=false
    local check_only=false
    local force_update=false
    local show_status_only=false
    local show_logs_only=false
    local quiet_mode=false
    local custom_retries=""
    
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
            -b|--backup)
                backup_only=true
                shift
                ;;
            -c|--check)
                check_only=true
                shift
                ;;
            -f|--force)
                force_update=true
                shift
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            -r|--retries)
                custom_retries="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Set custom retries if provided
    if [ -n "$custom_retries" ]; then
        if [[ "$custom_retries" =~ ^[0-9]+$ ]] && [ "$custom_retries" -gt 0 ]; then
            MAX_RETRIES="$custom_retries"
        else
            print_error "Invalid retries value: $custom_retries"
            exit 1
        fi
    fi
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Initialize log file
    echo "=== Homelab Services Update Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    if [ "$show_logs_only" = true ]; then
        show_logs
        exit 0
    fi
    
    if [ "$show_status_only" = true ]; then
        show_status
        exit 0
    fi
    
    if [ "$backup_only" = true ]; then
        create_backups_only
        cleanup_backups
        exit 0
    fi
    
    if [ "$check_only" = true ]; then
        check_updates_only
        exit 0
    fi
    
    log_message "Updating homelab services..."
    
    # Check Docker
    check_docker
    
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
    
    # Update services
    local failed_services=()
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ]; then
            if update_service "$full_path"; then
                log_message "Service $service_dir updated successfully"
            else
                log_message "Service $service_dir failed to update"
                failed_services+=("$service_dir")
            fi
        else
            log_message "Service directory $service_dir not found, skipping..."
        fi
    done
    
    # Cleanup old backups
    cleanup_backups
    
    # Show final status
    if [ "$quiet_mode" = false ]; then
        show_summary
    fi
    
    # Show failed services if any
    if [ ${#failed_services[@]} -gt 0 ]; then
        print_error "Failed to update services:"
        for service in "${failed_services[@]}"; do
            print_error "  - $service"
        done
        print_status "Check logs with: $0 --log"
        exit 1
    fi
    
    log_message "All services updated successfully"
    print_success "Homelab services update completed!"
}

# Run main function
main "$@" 