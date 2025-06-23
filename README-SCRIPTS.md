# Homelab Services Management Scripts

A comprehensive set of bash scripts for managing Docker-based homelab services with automatic service detection, port conflict checking, and robust error handling.

## 🚀 Features

- **Auto-Detection**: Automatically detects new service directories with `docker-compose.yml` files
- **Port Conflict Detection**: Checks for port conflicts before starting services
- **Dependency Management**: Starts core services first (homelab, additional, storage, network)
- **Health Monitoring**: Comprehensive health checks and status reporting
- **Backup Management**: Automatic backup creation and cleanup
- **Interactive Mode**: User-friendly interactive interface for service management
- **Logging**: Detailed logging for all operations
- **Error Handling**: Robust error handling with retry mechanisms

## 📁 Directory Structure

```
homelab/
├── start-all-services.sh      # Start all detected services
├── stop-all-services.sh       # Stop all services gracefully
├── restart-all-services.sh    # Restart all services
├── update-all-services.sh     # Update services with backups
├── maintenance.sh             # System maintenance and monitoring
├── quick-access.sh            # Interactive service management
├── README-SCRIPTS.md          # This documentation
├── PORT_ASSIGNMENTS.md        # Port assignment documentation
├── selfhosted.txt             # Service catalog
├── backups/                   # Automatic backups (created by scripts)
├── homelab/                   # Core homelab services
│   ├── docker-compose.yml
│   └── README-homelab.md
├── additional/                # Additional lightweight services
│   ├── docker-compose.yml
│   └── README-additional-services.md
├── storage/                   # Storage services
│   └── docker-compose.yml
├── network/                   # Network services
│   └── docker-compose.yml
├── jellyfin/                  # Media server
│   ├── docker-compose.yml
│   └── README-jellyfin.md
├── homeassistant/             # Home automation
│   ├── docker-compose.yml
│   └── README-homeassistant.md
├── pihole/                    # DNS ad blocker
│   ├── docker-compose.yml
│   └── README-pihole.md
├── wordpress/                 # Blog platform
│   └── docker-compose.yml
├── n8n/                       # Workflow automation
│   └── docker-compose.yml
├── puppeteer/                 # Web automation
│   └── docker-compose.yml
├── glances/                   # System monitoring
│   └── docker-compose.yml
└── urlwatch/                  # Website monitoring
    ├── docker-compose.yml
    ├── README-urlwatch.md
    └── config/
```

## 🔧 Scripts Overview

### 1. start-all-services.sh
**Purpose**: Start all detected services with dependency management and health checks.

**Features**:
- Auto-detects service directories
- Checks for port conflicts before starting
- Starts core services first (homelab, additional, storage, network)
- Health checks with retry mechanism
- Comprehensive logging

**Usage**:
```bash
./start-all-services.sh              # Start all services
./start-all-services.sh --status     # Show current status
./start-all-services.sh --check      # Check for port conflicts only
./start-all-services.sh --force      # Force restart running services
./start-all-services.sh --quiet      # Quiet mode
```

### 2. stop-all-services.sh
**Purpose**: Stop all services gracefully with proper shutdown sequence.

**Features**:
- Stops non-core services first (reverse dependency order)
- Graceful shutdown with timeout
- Force stop fallback if needed
- Removes stopped containers

**Usage**:
```bash
./stop-all-services.sh               # Stop all services gracefully
./stop-all-services.sh --status      # Show current status
./stop-all-services.sh --force       # Force stop all containers
./stop-all-services.sh --timeout 30  # Set custom timeout
```

### 3. restart-all-services.sh
**Purpose**: Restart all services with proper sequencing.

**Features**:
- Stops services before starting
- Individual service restart with health checks
- Force restart option
- Configurable retry attempts

**Usage**:
```bash
./restart-all-services.sh            # Restart all services
./restart-all-services.sh --force    # Force restart (stop all, start all)
./restart-all-services.sh --timeout 30  # Set shutdown timeout
./restart-all-services.sh --retries 5   # Set retry attempts
```

### 4. update-all-services.sh
**Purpose**: Update services with automatic backups and cleanup.

**Features**:
- Creates timestamped backups before updates
- Checks for available updates
- Removes old containers and images
- Automatic backup cleanup (keeps 5 most recent)
- Update-only and backup-only modes

**Usage**:
```bash
./update-all-services.sh             # Update all services
./update-all-services.sh --backup    # Create backups only
./update-all-services.sh --check     # Check for updates only
./update-all-services.sh --retries 5 # Set retry attempts
```

### 5. maintenance.sh
**Purpose**: System maintenance, monitoring, and cleanup.

**Features**:
- Service health checks
- Disk usage monitoring
- Docker resource cleanup
- Backup cleanup
- Comprehensive system status

**Usage**:
```bash
./maintenance.sh                     # Run basic checks
./maintenance.sh --all               # Run all maintenance tasks
./maintenance.sh --cleanup           # Cleanup only
./maintenance.sh --health            # Health checks only
./maintenance.sh --disk              # Disk usage check only
```

### 6. quick-access.sh
**Purpose**: Interactive service management and quick access.

**Features**:
- Interactive menu system
- Individual service control
- Browser integration
- Service information display
- Log viewing

**Usage**:
```bash
./quick-access.sh                    # Show all services status
./quick-access.sh --interactive      # Start interactive mode
./quick-access.sh start jellyfin     # Start specific service
./quick-access.sh open homeassistant # Open service in browser
./quick-access.sh logs pihole        # Show service logs
./quick-access.sh info wordpress     # Show service information
```

## 🔍 Auto-Detection System

The scripts automatically detect service directories by:
1. Scanning the script directory for subdirectories
2. Checking each subdirectory for a `docker-compose.yml` file
3. Adding valid service directories to the management list
4. Sorting services by dependency (core services first)

**Core Services** (started first):
- `homelab` - Core infrastructure
- `additional` - Lightweight services
- `storage` - Storage services
- `network` - Network services

**Adding New Services**:
1. Create a new directory in the script folder
2. Add a `docker-compose.yml` file to the directory
3. The scripts will automatically detect and manage the new service
4. No script modifications required!

## 🛡️ Port Conflict Detection

The scripts include robust port conflict detection:
- Scans `docker-compose.yml` files for port mappings
- Checks if ports are already in use
- Reports conflicts before starting services
- Prevents service startup if conflicts exist

**Port Conflict Check**:
```bash
./start-all-services.sh --check
```

## 📊 Health Monitoring

Comprehensive health monitoring includes:
- Service running status
- Container health checks
- Resource usage monitoring
- Disk space monitoring
- Docker resource monitoring

**Health Check**:
```bash
./maintenance.sh --health
```

## 💾 Backup System

Automatic backup system with:
- Timestamped backups before updates
- Configuration file preservation
- Automatic cleanup (keeps 5 most recent)
- Backup-only mode for manual backups

**Backup Management**:
```bash
./update-all-services.sh --backup    # Create backups
./maintenance.sh --cleanup           # Cleanup old backups
```

## 🔧 Configuration

### Environment Variables
The scripts use the following configuration:
- `SCRIPT_DIR`: Directory containing the scripts
- `SERVICES_DIR`: Directory containing service folders
- `LOG_FILE`: Log file location for each script
- `BACKUP_DIR`: Backup directory location
- `MAX_RETRIES`: Maximum retry attempts (default: 3)
- `RETRY_DELAY`: Delay between retries (default: 30s)
- `TIMEOUT`: Graceful shutdown timeout (default: 60s)

### Log Files
Each script creates its own log file:
- `startup.log` - Service startup logs
- `shutdown.log` - Service shutdown logs
- `restart.log` - Service restart logs
- `update.log` - Service update logs
- `maintenance.log` - Maintenance operation logs
- `quick-access.log` - Quick access operation logs

## 🚨 Error Handling

The scripts include comprehensive error handling:
- Docker availability checks
- Service dependency validation
- Port conflict detection
- Retry mechanisms for failed operations
- Graceful fallbacks for critical failures
- Detailed error reporting

## 🔒 Security Considerations

- Scripts run with current user permissions
- No elevated privileges required
- Docker socket access only
- No sensitive data in logs
- Backup encryption recommended for sensitive data

## 📝 Best Practices

1. **Regular Maintenance**: Run `./maintenance.sh --all` weekly
2. **Backup Strategy**: Use `./update-all-services.sh --backup` before major changes
3. **Monitoring**: Use `./quick-access.sh --interactive` for daily monitoring
4. **Updates**: Run `./update-all-services.sh` monthly
5. **Log Rotation**: Monitor log file sizes and clean up as needed

## 🆘 Troubleshooting

### Common Issues

**Services won't start**:
```bash
./start-all-services.sh --check      # Check for port conflicts
./maintenance.sh --health            # Check service health
./quick-access.sh logs <service>     # Check service logs
```

**High disk usage**:
```bash
./maintenance.sh --disk              # Check disk usage
./maintenance.sh --cleanup           # Cleanup Docker resources
```

**Service not detected**:
- Ensure directory contains `docker-compose.yml`
- Check directory permissions
- Verify `docker-compose.yml` syntax

**Port conflicts**:
- Check `PORT_ASSIGNMENTS.md` for port assignments
- Modify port mappings in `docker-compose.yml`
- Stop conflicting services

### Getting Help

1. Check script logs: `./<script>.sh --log`
2. Run health checks: `./maintenance.sh --health`
3. Check service status: `./quick-access.sh --status`
4. Review this documentation
5. Check individual service README files

## 🔄 Version History

### Version 2.0 (Current)
- ✅ Auto-detection of service directories
- ✅ Port conflict detection
- ✅ Enhanced error handling
- ✅ Improved logging
- ✅ Interactive mode improvements
- ✅ Backup system enhancements
- ✅ Health monitoring improvements

### Version 1.0
- Basic service management
- Hardcoded service lists
- Simple start/stop functionality

## 📄 License

This project is open source. Feel free to modify and distribute according to your needs.

## 🤝 Contributing

To add new features or improve the scripts:
1. Test thoroughly with your setup
2. Update documentation
3. Follow existing code style
4. Include error handling
5. Add appropriate logging

---

**Happy Homelabbing! 🏠**

For more information, check the individual service directories and the comprehensive service directory in `selfhosted.txt`. 