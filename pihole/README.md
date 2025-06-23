# Pi-hole

A network-wide ad blocker that acts as a DNS sinkhole.

## Features
- Network-wide ad blocking
- DNS server
- Web interface for management
- Query logging
- Whitelist/blacklist management
- Statistics and analytics
- DHCP server (optional)

## Quick Start
1. Start Pi-hole:
   ```bash
   docker-compose up -d
   ```
2. Access the admin panel at [http://localhost:4012](http://localhost:4012)
3. Default password: `adminpassword`

## Configuration
- Pi-hole config: `./etc-pihole`
- DNS config: `./etc-dnsmasq.d`

## Environment Variables
- `TZ`: Timezone (default: UTC)
- `WEBPASSWORD`: Admin password
- `PIHOLE_DNS_`: Upstream DNS servers

## Ports
- Web UI: 4012
- DNS: 53 (TCP/UDP)

## Setup Instructions
1. Configure your router to use Pi-hole as DNS server
2. Or configure individual devices to use Pi-hole DNS
3. Access admin panel to view statistics and manage lists

## Blocklists
Pi-hole comes with default blocklists. You can add more:
- Go to Group Management > Adlists
- Add URLs of additional blocklists
- Update gravity to apply changes

## Docs
- [Official Documentation](https://docs.pi-hole.net/)
- [GitHub](https://github.com/pi-hole/pi-hole)
- [Blocklists](https://firebog.net/)

## Tips
- Use Pi-hole as your primary DNS server
- Regularly update blocklists
- Monitor query logs for troubleshooting
- Whitelist legitimate sites that get blocked
- Set up backup DNS servers 