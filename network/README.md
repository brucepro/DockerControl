# Network Services

Collection of network-related services for monitoring and management.

## Services Included

### Speedtest
- Network speed testing
- Web interface for speed tests
- Historical data tracking

### Nmap
- Network scanning and discovery
- Port scanning
- Service detection
- Security auditing

### ntopng
- Network traffic analysis
- Real-time monitoring
- Flow analysis
- Traffic visualization

## Quick Start
1. Start network services:
   ```bash
   docker-compose up -d
   ```
2. Access individual services:
   - Speedtest: [http://localhost:4038](http://localhost:4038)
   - Nmap: [http://localhost:4037](http://localhost:4037)
   - ntopng: [http://localhost:3002](http://localhost:3002)

## Configuration
- Speedtest config: `./speedtest`
- Nmap scans: `./nmap/scans`
- ntopng data: `./ntopng`

## Use Cases
- **Network Diagnostics**: Troubleshoot connectivity issues
- **Security Auditing**: Scan for open ports and services
- **Performance Monitoring**: Track network performance
- **Traffic Analysis**: Monitor network usage patterns

## Security Considerations
- Nmap requires network access
- Some scans may be detected by security systems
- Use responsibly and only on your own networks

## Docs
- [Speedtest](https://github.com/linuxserver/docker-speedtest)
- [Nmap](https://nmap.org/book/)
- [ntopng](https://www.ntop.org/products/traffic-analysis/ntop/)

## Tips
- Use for network troubleshooting
- Monitor network performance regularly
- Keep scan results for historical analysis
- Configure alerts for network issues 