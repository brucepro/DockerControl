#!/bin/bash

# Homelab Services Migration Script
# Discover and migrate existing Docker containers
# Author: Homelab Manager
# Version: 1.0

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
LOG_FILE="$SCRIPT_DIR/migration.log"
MIGRATION_DIR="$SCRIPT_DIR/migration"
BACKUP_DIR="$SCRIPT_DIR/backups"

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
        exit 1
    fi
    print_success "Docker is running"
}

# Function to discover running containers
discover_containers() {
    print_status "Discovering running Docker containers..."
    
    local containers=()
    local container_info=()
    
    # Get all running containers with their details
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            containers+=("$line")
        fi
    done < <(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}")
    
    # Skip header line
    for ((i=1; i<${#containers[@]}; i++)); do
        local container="${containers[$i]}"
        local name=$(echo "$container" | awk '{print $1}')
        local image=$(echo "$container" | awk '{print $2}')
        local ports=$(echo "$container" | awk '{print $3}')
        local status=$(echo "$container" | awk '{print $4}')
        
        container_info+=("$name|$image|$ports|$status")
    done
    
    echo "${container_info[@]}"
}

# Function to discover docker-compose projects
discover_compose_projects() {
    print_status "Discovering Docker Compose projects..."
    
    local projects=()
    
    # Look for docker-compose.yml files in common locations
    local search_paths=(
        "$HOME"
        "/opt"
        "/var/lib/docker"
        "/docker"
        "/home/*/docker"
        "/home/*/homelab"
        "/home/*/services"
    )
    
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            while IFS= read -r -d '' file; do
                local dir=$(dirname "$file")
                local project_name=$(basename "$dir")
                projects+=("$project_name|$dir|$file")
            done < <(find "$path" -name "docker-compose.yml" -print0 2>/dev/null)
        fi
    done
    
    echo "${projects[@]}"
}

# Function to analyze container and suggest service type
analyze_container() {
    local container_name="$1"
    local image="$2"
    local ports="$3"
    
    local service_type="unknown"
    local suggested_name="$container_name"
    
    # Analyze based on image name
    case "$image" in
        *jellyfin*|*emby*|*plex*)
            service_type="media"
            suggested_name="jellyfin"
            ;;
        *homeassistant*|*home-assistant*)
            service_type="automation"
            suggested_name="homeassistant"
            ;;
        *pihole*|*adguard*)
            service_type="network"
            suggested_name="pihole"
            ;;
        *wordpress*|*nginx*|*apache*)
            service_type="web"
            suggested_name="wordpress"
            ;;
        *n8n*|*node-red*)
            service_type="automation"
            suggested_name="n8n"
            ;;
        *kiwix*)
            service_type="knowledge"
            suggested_name="kiwix"
            ;;
        *calibre*)
            service_type="media"
            suggested_name="calibre"
            ;;
        *mealie*)
            service_type="lifestyle"
            suggested_name="mealie"
            ;;
        *nextcloud*|*owncloud*)
            service_type="storage"
            suggested_name="nextcloud"
            ;;
        *mysql*|*postgres*|*mariadb*)
            service_type="database"
            suggested_name="database"
            ;;
        *redis*|*memcached*)
            service_type="cache"
            suggested_name="cache"
            ;;
        *grafana*|*prometheus*)
            service_type="monitoring"
            suggested_name="monitoring"
            ;;
        *)
            service_type="custom"
            suggested_name="$container_name"
            ;;
    esac
    
    echo "$service_type|$suggested_name"
}

# Function to generate docker-compose.yml template
generate_compose_template() {
    local service_name="$1"
    local image="$2"
    local ports="$3"
    local volumes="$4"
    local environment="$5"
    
    cat > "$MIGRATION_DIR/$service_name/docker-compose.yml" << EOF
version: '3.8'

services:
  $service_name:
    image: $image
    container_name: $service_name
    restart: unless-stopped
EOF
    
    # Add ports if specified
    if [ -n "$ports" ]; then
        echo "    ports:" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
        IFS=',' read -ra PORT_ARRAY <<< "$ports"
        for port in "${PORT_ARRAY[@]}"; do
            if [ -n "$port" ]; then
                echo "      - \"$port\"" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
            fi
        done
    fi
    
    # Add volumes if specified
    if [ -n "$volumes" ]; then
        echo "    volumes:" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
        IFS=',' read -ra VOLUME_ARRAY <<< "$volumes"
        for volume in "${VOLUME_ARRAY[@]}"; do
            if [ -n "$volume" ]; then
                echo "      - $volume" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
            fi
        done
    fi
    
    # Add environment variables if specified
    if [ -n "$environment" ]; then
        echo "    environment:" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
        IFS=',' read -ra ENV_ARRAY <<< "$environment"
        for env in "${ENV_ARRAY[@]}"; do
            if [ -n "$env" ]; then
                echo "      - $env" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
            fi
        done
    fi
    
    # Add networks
    cat >> "$MIGRATION_DIR/$service_name/docker-compose.yml" << EOF
    networks:
      - ${service_name}_network

networks:
  ${service_name}_network:
    driver: bridge

volumes:
EOF
    
    # Add volume definitions if volumes exist
    if [ -n "$volumes" ]; then
        IFS=',' read -ra VOLUME_ARRAY <<< "$volumes"
        for volume in "${VOLUME_ARRAY[@]}"; do
            if [[ "$volume" == *":"* ]]; then
                local volume_name=$(echo "$volume" | cut -d':' -f1)
                if [[ "$volume_name" != "/"* ]]; then
                    echo "  $volume_name:" >> "$MIGRATION_DIR/$service_name/docker-compose.yml"
                fi
            fi
        done
    fi
}

# Function to extract container configuration
extract_container_config() {
    local container_name="$1"
    
    print_status "Extracting configuration for container: $container_name"
    
    # Get container details
    local image=$(docker inspect "$container_name" --format '{{.Config.Image}}')
    local ports=$(docker inspect "$container_name" --format '{{range $k, $v := .NetworkSettings.Ports}}{{$k}} {{end}}')
    local volumes=$(docker inspect "$container_name" --format '{{range .Mounts}}{{.Source}}:{{.Destination}},{{end}}')
    local env_vars=$(docker inspect "$container_name" --format '{{range .Config.Env}}{{.}},{{end}}')
    
    # Clean up the extracted data
    ports=$(echo "$ports" | tr ' ' '\n' | grep -v '^$' | tr '\n' ',' | sed 's/,$//')
    volumes=$(echo "$volumes" | sed 's/,$//')
    env_vars=$(echo "$env_vars" | sed 's/,$//')
    
    echo "$image|$ports|$volumes|$env_vars"
}

# Function to create service directory
create_service_directory() {
    local service_name="$1"
    local service_type="$2"
    
    local target_dir="$SERVICES_DIR/$service_name"
    
    if [ -d "$target_dir" ]; then
        print_warning "Service directory $service_name already exists"
        return 1
    fi
    
    mkdir -p "$target_dir"
    print_success "Created service directory: $target_dir"
    
    # Create README
    cat > "$target_dir/README.md" << EOF
# $service_name

Migrated from existing Docker container.

## Service Type
$service_type

## Migration Date
$(date '+%Y-%m-%d %H:%M:%S')

## Original Container
- Container Name: $service_name
- Migrated using: migrate-existing-dockers.sh

## Configuration
- Docker Compose file: docker-compose.yml
- Configuration files: (if any)

## Usage
\`\`\`bash
# Start the service
docker-compose up -d

# Stop the service
docker-compose down

# View logs
docker-compose logs -f
\`\`\`

## Notes
- This service was automatically migrated from an existing container
- Review and adjust the configuration as needed
- Update passwords and security settings
- Test thoroughly before production use
EOF
    
    print_success "Created README for $service_name"
}

# Function to migrate container
migrate_container() {
    local container_name="$1"
    local image="$2"
    local ports="$3"
    local volumes="$4"
    local environment="$5"
    
    print_status "Migrating container: $container_name"
    
    # Analyze container
    local analysis=$(analyze_container "$container_name" "$image" "$ports")
    local service_type=$(echo "$analysis" | cut -d'|' -f1)
    local suggested_name=$(echo "$analysis" | cut -d'|' -f2)
    
    print_info "Service type: $service_type"
    print_info "Suggested name: $suggested_name"
    
    # Create service directory
    if create_service_directory "$suggested_name" "$service_type"; then
        # Generate docker-compose.yml
        generate_compose_template "$suggested_name" "$image" "$ports" "$volumes" "$environment"
        print_success "Generated docker-compose.yml for $suggested_name"
        
        # Copy to target location
        cp "$MIGRATION_DIR/$suggested_name/docker-compose.yml" "$SERVICES_DIR/$suggested_name/"
        print_success "Migrated $container_name to $suggested_name"
        
        return 0
    else
        print_error "Failed to create service directory for $suggested_name"
        return 1
    fi
}

# Function to show discovered containers
show_discovered_containers() {
    print_status "Discovered running containers:"
    echo "========================================"
    
    local containers=($(discover_containers))
    local count=0
    
    for container_info in "${containers[@]}"; do
        if [ -n "$container_info" ]; then
            local name=$(echo "$container_info" | cut -d'|' -f1)
            local image=$(echo "$container_info" | cut -d'|' -f2)
            local ports=$(echo "$container_info" | cut -d'|' -f3)
            local status=$(echo "$container_info" | cut -d'|' -f4)
            
            print_info "Container: $name"
            print_info "  Image: $image"
            print_info "  Ports: $ports"
            print_info "  Status: $status"
            echo ""
            ((count++))
        fi
    done
    
    echo "========================================"
    print_status "Total containers discovered: $count"
}

# Function to show discovered compose projects
show_discovered_projects() {
    print_status "Discovered Docker Compose projects:"
    echo "========================================"
    
    local projects=($(discover_compose_projects))
    local count=0
    
    for project_info in "${projects[@]}"; do
        if [ -n "$project_info" ]; then
            local name=$(echo "$project_info" | cut -d'|' -f1)
            local dir=$(echo "$project_info" | cut -d'|' -f2)
            local file=$(echo "$project_info" | cut -d'|' -f3)
            
            print_info "Project: $name"
            print_info "  Directory: $dir"
            print_info "  Compose file: $file"
            echo ""
            ((count++))
        fi
    done
    
    echo "========================================"
    print_status "Total projects discovered: $count"
}

# Function to show help
show_help() {
    echo "Homelab Services Migration Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -d, --discover Show discovered containers and projects"
    echo "  -m, --migrate  Migrate discovered containers"
    echo "  -a, --analyze  Analyze containers without migrating"
    echo "  -c, --containers-only  Only show containers"
    echo "  -p, --projects-only    Only show compose projects"
    echo ""
    echo "Examples:"
    echo "  $0 --discover           # Show all discovered containers and projects"
    echo "  $0 --migrate            # Migrate all discovered containers"
    echo "  $0 --analyze            # Analyze containers without migrating"
    echo "  $0 --containers-only    # Show only running containers"
    echo ""
}

# Function to analyze all containers
analyze_all_containers() {
    print_status "Analyzing all discovered containers..."
    echo "========================================"
    
    local containers=($(discover_containers))
    local analysis_results=()
    
    for container_info in "${containers[@]}"; do
        if [ -n "$container_info" ]; then
            local name=$(echo "$container_info" | cut -d'|' -f1)
            local image=$(echo "$container_info" | cut -d'|' -f2)
            local ports=$(echo "$container_info" | cut -d'|' -f3)
            
            local analysis=$(analyze_container "$name" "$image" "$ports")
            local service_type=$(echo "$analysis" | cut -d'|' -f1)
            local suggested_name=$(echo "$analysis" | cut -d'|' -f2)
            
            print_info "Container: $name"
            print_info "  Image: $image"
            print_info "  Service Type: $service_type"
            print_info "  Suggested Name: $suggested_name"
            print_info "  Ports: $ports"
            echo ""
            
            analysis_results+=("$name|$suggested_name|$service_type")
        fi
    done
    
    # Save analysis results
    echo "Analysis Results:" > "$MIGRATION_DIR/analysis_results.txt"
    echo "Generated: $(date)" >> "$MIGRATION_DIR/analysis_results.txt"
    echo "" >> "$MIGRATION_DIR/analysis_results.txt"
    
    for result in "${analysis_results[@]}"; do
        echo "$result" >> "$MIGRATION_DIR/analysis_results.txt"
    done
    
    print_success "Analysis saved to: $MIGRATION_DIR/analysis_results.txt"
}

# Function to migrate all containers
migrate_all_containers() {
    print_status "Starting migration of all discovered containers..."
    
    # Create migration directory
    mkdir -p "$MIGRATION_DIR"
    
    local containers=($(discover_containers))
    local migrated_count=0
    local failed_count=0
    
    for container_info in "${containers[@]}"; do
        if [ -n "$container_info" ]; then
            local name=$(echo "$container_info" | cut -d'|' -f1)
            local image=$(echo "$container_info" | cut -d'|' -f2)
            local ports=$(echo "$container_info" | cut -d'|' -f3)
            
            # Extract container configuration
            local config=$(extract_container_config "$name")
            local extracted_image=$(echo "$config" | cut -d'|' -f1)
            local extracted_ports=$(echo "$config" | cut -d'|' -f2)
            local extracted_volumes=$(echo "$config" | cut -d'|' -f3)
            local extracted_env=$(echo "$config" | cut -d'|' -f4)
            
            if migrate_container "$name" "$extracted_image" "$extracted_ports" "$extracted_volumes" "$extracted_env"; then
                ((migrated_count++))
            else
                ((failed_count++))
            fi
        fi
    done
    
    echo "========================================"
    print_status "Migration Summary:"
    print_status "Successfully migrated: $migrated_count"
    print_status "Failed migrations: $failed_count"
    
    if [ $migrated_count -gt 0 ]; then
        print_success "Migration completed! Review the generated files and test the services."
        print_info "Next steps:"
        print_info "1. Review the generated docker-compose.yml files"
        print_info "2. Update passwords and security settings"
        print_info "3. Test each service individually"
        print_info "4. Use the management scripts to start services"
    fi
}

# Main execution
main() {
    local discover_only=false
    local migrate_mode=false
    local analyze_mode=false
    local containers_only=false
    local projects_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--discover)
                discover_only=true
                shift
                ;;
            -m|--migrate)
                migrate_mode=true
                shift
                ;;
            -a|--analyze)
                analyze_mode=true
                shift
                ;;
            -c|--containers-only)
                containers_only=true
                shift
                ;;
            -p|--projects-only)
                projects_only=true
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
    echo "=== Homelab Migration Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    log_message "Starting migration script..."
    
    # Check Docker
    check_docker
    
    # Create migration directory
    mkdir -p "$MIGRATION_DIR"
    
    # Handle different modes
    if [ "$discover_only" = true ]; then
        if [ "$containers_only" = true ]; then
            show_discovered_containers
        elif [ "$projects_only" = true ]; then
            show_discovered_projects
        else
            show_discovered_containers
            echo ""
            show_discovered_projects
        fi
        exit 0
    fi
    
    if [ "$analyze_mode" = true ]; then
        analyze_all_containers
        exit 0
    fi
    
    if [ "$migrate_mode" = true ]; then
        migrate_all_containers
        exit 0
    fi
    
    # Default behavior: show help
    show_help
}

# Run main function
main "$@" 