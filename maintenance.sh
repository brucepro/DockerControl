#!/bin/bash

# Homelab Services Management Script
# Maintenance and Monitoring
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
LOG_FILE="$SCRIPT_DIR/maintenance.log"
BACKUP_DIR="$SCRIPT_DIR/backups"
CLEANUP_DAYS=30

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
    
    echo "${services[@]}"
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

# Function to display service status
show_status() {
    print_status "Current service status:"
    echo "----------------------------------------"
    
    local services=($(detect_services))
    local running_count=0
    local total_count=0
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -f "$full_path/docker-compose.yml" ]; then
            ((total_count++))
            if is_service_running "$full_path"; then
                print_success "$service_dir: RUNNING"
                ((running_count++))
            else
                print_error "$service_dir: STOPPED"
            fi
        else
            print_warning "$service_dir: NO CONFIG"
        fi
    done
    
    echo "----------------------------------------"
    print_status "Total services: $total_count"
    print_status "Running: $running_count"
    print_status "Stopped: $((total_count - running_count))"
    
    if [ $running_count -eq $total_count ]; then
        print_success "All services are running!"
    else
        print_warning "Some services are stopped."
    fi
}

# Function to check service health
check_service_health() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    
    if [ ! -f "$service_dir/docker-compose.yml" ]; then
        return 0
    fi
    
    print_status "Checking health of $service_name..."
    
    # Check if service is running
    if ! is_service_running "$service_dir"; then
        print_error "$service_name is not running"
        return 1
    fi
    
    # Check container status
    local containers=$(docker-compose -f "$service_dir/docker-compose.yml" ps -q)
    local healthy_count=0
    local total_count=0
    
    for container in $containers; do
        ((total_count++))
        local status=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null)
        local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
        
        if [ "$status" = "running" ] && ([ "$health" = "healthy" ] || [ "$health" = "<nil>" ]); then
            ((healthy_count++))
        else
            print_warning "Container $container in $service_name: $status ($health)"
        fi
    done
    
    if [ $healthy_count -eq $total_count ]; then
        print_success "$service_name is healthy"
        return 0
    else
        print_warning "$service_name has unhealthy containers"
        return 1
    fi
}

# Function to check all services health
check_all_health() {
    print_status "Checking health of all services..."
    
    local services=($(detect_services))
    local healthy_count=0
    local total_count=0
    
    for service_dir in "${services[@]}"; do
        local full_path="$SERVICES_DIR/$service_dir"
        
        if [ -d "$full_path" ] && [ -f "$full_path/docker-compose.yml" ]; then
            ((total_count++))
            if check_service_health "$full_path"; then
                ((healthy_count++))
            fi
        fi
    done
    
    echo "----------------------------------------"
    print_status "Health check summary:"
    print_status "Total services: $total_count"
    print_status "Healthy: $healthy_count"
    print_status "Unhealthy: $((total_count - healthy_count))"
    
    if [ $healthy_count -eq $total_count ]; then
        print_success "All services are healthy!"
    else
        print_warning "Some services are unhealthy."
    fi
}

# Function to cleanup Docker resources
cleanup_docker() {
    print_status "Cleaning up Docker resources..."
    
    # Remove stopped containers
    local stopped_containers=$(docker ps -aq --filter "status=exited")
    if [ -n "$stopped_containers" ]; then
        print_status "Removing stopped containers..."
        docker rm $stopped_containers
        print_success "Removed stopped containers"
    else
        print_status "No stopped containers found"
    fi
    
    # Remove dangling images
    print_status "Removing dangling images..."
    docker image prune -f
    print_success "Removed dangling images"
    
    # Remove unused networks
    print_status "Removing unused networks..."
    docker network prune -f
    print_success "Removed unused networks"
    
    # Remove unused volumes (be careful with this)
    print_status "Removing unused volumes..."
    docker volume prune -f
    print_success "Removed unused volumes"
    
    # Remove old images (older than 30 days)
    print_status "Removing old images (older than $CLEANUP_DAYS days)..."
    docker image prune -a --filter "until=${CLEANUP_DAYS}d" -f
    print_success "Removed old images"
}

# Function to cleanup old backups
cleanup_backups() {
    print_status "Cleaning up old backups..."
    
    if [ ! -d "$BACKUP_DIR" ]; then
        print_status "No backup directory found"
        return 0
    fi
    
    local max_backups=5
    local removed_count=0
    
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
                ((removed_count++))
            fi
        done
    done
    
    print_success "Removed $removed_count old backups"
}

# Function to check disk usage
check_disk_usage() {
    print_status "Checking disk usage..."
    
    # Check overall disk usage
    local disk_usage=$(df -h . | tail -1 | awk '{print $5}' | sed 's/%//')
    local disk_available=$(df -h . | tail -1 | awk '{print $4}')
    
    print_status "Disk usage: ${disk_usage}% (${disk_available} available)"
    
    if [ "$disk_usage" -gt 90 ]; then
        print_error "Disk usage is critical (>90%)"
        return 1
    elif [ "$disk_usage" -gt 80 ]; then
        print_warning "Disk usage is high (>80%)"
        return 1
    else
        print_success "Disk usage is normal"
        return 0
    fi
}

# Function to check Docker disk usage
check_docker_disk_usage() {
    print_status "Checking Docker disk usage..."
    
    # Get Docker disk usage
    local docker_usage=$(docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}")
    
    echo "$docker_usage"
    
    # Check if cleanup is needed
    local reclaimable=$(docker system df --format "{{.Reclaimable}}" | tail -1)
    if [ -n "$reclaimable" ] && [ "$reclaimable" != "0B" ]; then
        print_warning "Docker has reclaimable space: $reclaimable"
        return 1
    else
        print_success "Docker disk usage is optimal"
        return 0
    fi
}

# Function to show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo "=== Maintenance Log ==="
        tail -50 "$LOG_FILE"
    else
        print_warning "No log file found"
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
    echo "  -l, --log      Show maintenance log"
    echo "  -c, --cleanup  Perform cleanup operations"
    echo "  -d, --disk     Check disk usage"
    echo "  -k, --health   Check service health"
    echo "  -q, --quiet    Quiet mode (minimal output)"
    echo "  -a, --all      Run all maintenance tasks"
    echo ""
    echo "Examples:"
    echo "  $0              # Show status and run basic checks"
    echo "  $0 --status     # Show current status"
    echo "  $0 --cleanup    # Clean up Docker resources and backups"
    echo "  $0 --disk       # Check disk usage"
    echo "  $0 --health     # Check service health"
    echo "  $0 --all        # Run all maintenance tasks"
    echo ""
}

# Function to run all maintenance tasks
run_all_maintenance() {
    print_status "Running all maintenance tasks..."
    
    # Check Docker
    check_docker
    
    # Show status
    show_status
    
    # Check health
    check_all_health
    
    # Check disk usage
    check_disk_usage
    check_docker_disk_usage
    
    # Cleanup
    cleanup_docker
    cleanup_backups
    
    print_success "All maintenance tasks completed!"
}

# Main execution
main() {
    local show_status_only=false
    local show_logs_only=false
    local cleanup_only=false
    local disk_check_only=false
    local health_check_only=false
    local run_all=false
    local quiet_mode=false
    
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
            -c|--cleanup)
                cleanup_only=true
                shift
                ;;
            -d|--disk)
                disk_check_only=true
                shift
                ;;
            -k|--health)
                health_check_only=true
                shift
                ;;
            -a|--all)
                run_all=true
                shift
                ;;
            -q|--quiet)
                quiet_mode=true
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
    echo "=== Homelab Services Maintenance Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    if [ "$show_logs_only" = true ]; then
        show_logs
        exit 0
    fi
    
    if [ "$show_status_only" = true ]; then
        show_status
        exit 0
    fi
    
    if [ "$cleanup_only" = true ]; then
        check_docker
        cleanup_docker
        cleanup_backups
        exit 0
    fi
    
    if [ "$disk_check_only" = true ]; then
        check_disk_usage
        check_docker_disk_usage
        exit 0
    fi
    
    if [ "$health_check_only" = true ]; then
        check_docker
        check_all_health
        exit 0
    fi
    
    if [ "$run_all" = true ]; then
        run_all_maintenance
        exit 0
    fi
    
    # Default behavior: show status and run basic checks
    log_message "Running maintenance checks..."
    
    # Check Docker
    check_docker
    
    # Show status
    show_status
    
    # Check disk usage
    check_disk_usage
    
    # Check Docker disk usage
    check_docker_disk_usage
    
    log_message "Maintenance checks completed"
    print_success "Maintenance completed!"
}

# Run main function
main "$@" 