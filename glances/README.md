# Glances

A cross-platform monitoring tool that provides real-time system information.

## Features
- Real-time system monitoring
- Web interface
- CPU, memory, disk usage
- Network monitoring
- Process management
- Docker container monitoring
- Plugin system

## Quick Start
1. Start Glances:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:61208](http://localhost:61208)
3. View system statistics

## Configuration
- Config: `./config`
- Logs: `./logs`

## Environment Variables
- `GLANCES_OPT`: Glances options
- `TZ`: Timezone

## Ports
- Web UI: 61208
- Grafana: 4059

## Features
- **System Overview**: CPU, memory, disk, network
- **Process List**: Running processes with details
- **Docker Monitoring**: Container statistics
- **Network**: Interface statistics
- **Disk I/O**: Storage performance
- **Sensors**: Temperature and hardware info

## Web Interface
- Real-time updates
- Responsive design
- Dark/light themes
- Export data
- Customizable views

## Integration
- Grafana dashboards
- InfluxDB storage
- Prometheus metrics
- REST API

## Docs
- [Official Documentation](https://glances.readthedocs.io/)
- [GitHub](https://github.com/nicolargo/glances)
- [Web Interface](https://github.com/nicolargo/glances-web)

## Tips
- Use for system troubleshooting
- Monitor resource usage
- Identify performance bottlenecks
- Track Docker containers
- Set up alerts for high usage 