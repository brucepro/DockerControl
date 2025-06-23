# Pi-hole - Network-Wide Ad Blocker

## Why Pi-hole?

**Pi-hole** was chosen as the network ad blocking solution because it's:

- **Network-Wide**: Blocks ads for all devices on your network
- **Privacy-Focused**: No tracking or data collection
- **Lightweight**: Minimal resource usage
- **Customizable**: Extensive blocklist and whitelist options
- **Open Source**: Transparent and community-driven
- **DNS Server**: Provides fast, reliable DNS resolution
- **Web Interface**: Easy management and monitoring

## What Pi-hole Does

Pi-hole is a DNS sinkhole that:

- **Blocks Advertisements**: Prevents ads from loading across your entire network
- **Blocks Trackers**: Stops tracking scripts and analytics
- **Improves Privacy**: Reduces data collection by advertisers
- **Speeds Up Browsing**: Faster page loads without ad requests
- **Provides DNS**: Acts as your network's DNS server
- **Monitors Traffic**: Shows detailed statistics and logs
- **Custom Blocking**: Block specific domains or categories

## Quick Start

1. **Create configuration directories**:
```bash
mkdir -p pihole/{etc-pihole,etc-dnsmasq.d,logs}
```

2. **Start Pi-hole**:
```bash
docker-compose -f docker-compose-network.yml up pihole -d
```

3. **Access the web interface** at `http://localhost:8082`

4. **Configure your router** to use Pi-hole as DNS server:
   - Set DNS server to your Pi-hole IP address
   - Or configure DHCP to assign Pi-hole as DNS

5. **Set admin password**:
   - Default password: `adminpassword`
   - Change in web interface: Settings → Web Interface

## Configuration

### Basic Setup
```yaml
environment:
  - WEBPASSWORD=your-secure-password
  - PIHOLE_DNS_=8.8.8.8;8.8.4.4
  - ServerIP=192.168.1.10
```

### Advanced Configuration
```yaml
environment:
  - PIHOLE_DNS_=1.1.1.1;1.0.0.1
  - DNSMASQ_USER=pihole
  - VIRTUAL_HOST=pihole.local
  - PROXY_LOCATION=pihole
  - DNSMASQ_LISTENING=all
```

### Custom Blocklists
Add custom blocklists in the web interface:
1. Go to Group Management → Adlists
2. Add URLs like:
   - `https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts`
   - `https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt`
   - `https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts`

## Features & Capabilities

### Ad Blocking
- **Network-Wide**: Blocks ads for all devices
- **Multiple Protocols**: HTTP, HTTPS, DNS over HTTPS
- **Custom Rules**: Whitelist/blacklist specific domains
- **Regex Support**: Advanced pattern matching
- **Temporary Disabling**: Quick toggle for troubleshooting

### DNS Features
- **Fast Resolution**: Caches DNS queries
- **Multiple Upstream**: Configure multiple DNS providers
- **Conditional Forwarding**: Route specific domains
- **DNS over HTTPS**: Secure DNS queries
- **Custom Records**: Add local DNS entries

### Monitoring & Statistics
- **Real-time Dashboard**: Live traffic monitoring
- **Query Logs**: Detailed DNS query history
- **Top Domains**: Most requested domains
- **Top Clients**: Devices making most requests
- **Blocking Statistics**: Ad blocking effectiveness

### Security Features
- **Query Logging**: Monitor network activity
- **Malware Protection**: Block known malicious domains
- **Phishing Protection**: Block phishing sites
- **Custom Filters**: Block specific content types

## Advanced Configuration

### Custom DNS Records
Add local DNS entries in the web interface:
1. Go to Local DNS → DNS Records
2. Add entries like:
   - `router.local` → `192.168.1.1`
   - `nas.local` → `192.168.1.100`
   - `homeassistant.local` → `192.168.1.200`

### Conditional Forwarding
Route specific domains to different DNS servers:
```bash
# Example: Route .local domains to router
echo "server=/local/192.168.1.1" >> /etc/dnsmasq.d/01-custom.conf
```

### Custom Blocklists
Create custom blocklists:
```bash
# Create custom blocklist
cat > /etc/pihole/custom.list << EOF
ads.example.com
tracking.example.com
analytics.example.com
EOF
```

### API Access
Use Pi-hole's API for automation:
```bash
# Get statistics
curl "http://localhost:8082/admin/api.php?summary"

# Disable Pi-hole for 30 seconds
curl -X GET "http://localhost:8082/admin/api.php?disable=30&auth=YOUR_API_TOKEN"
```

## Integration Examples

### Home Assistant Integration
Add Pi-hole to Home Assistant:
```yaml
# configuration.yaml
sensor:
  - platform: pi_hole
    host: 192.168.1.10
    api_key: your-api-key
    monitored_conditions:
      - ads_blocked_today
      - percentage_ads_blocked
      - queries_cached
      - queries_forwarded
```

### Grafana Dashboard
Monitor Pi-hole with Grafana:
1. Add Pi-hole as data source
2. Import Pi-hole dashboard
3. Monitor blocking statistics

### Uptime Monitoring
Monitor Pi-hole availability:
1. Add to Uptime Kuma
2. Monitor DNS resolution
3. Set up alerts for downtime

## Troubleshooting

### Common Issues

1. **Devices Not Using Pi-hole**:
   - Check router DNS settings
   - Verify DHCP configuration
   - Test DNS resolution manually

2. **Ads Still Showing**:
   - Check blocklist coverage
   - Add custom blocklists
   - Review query logs

3. **Slow DNS Resolution**:
   - Check upstream DNS servers
   - Monitor network connectivity
   - Review cache settings

4. **Web Interface Not Accessible**:
   - Check container status
   - Verify port mapping
   - Review firewall settings

### Debug Commands
```bash
# Check Pi-hole status
docker exec pihole pihole status

# View DNS queries
docker exec pihole tail -f /var/log/pihole.log

# Test DNS resolution
docker exec pihole nslookup google.com

# Check blocklist
docker exec pihole pihole -g
```

### Logs
View Pi-hole logs:
```bash
# Container logs
docker-compose -f docker-compose-network.yml logs pihole

# DNS query logs
docker exec pihole tail -f /var/log/pihole.log

# DNSMasq logs
docker exec pihole tail -f /var/log/dnsmasq.log
```

## Performance Optimization

### Resource Requirements
- **CPU**: Minimal (single core sufficient)
- **RAM**: 512MB minimum, 1GB recommended
- **Storage**: 1GB for logs and cache
- **Network**: Any stable connection

### Optimization Tips
1. **Use Fast Upstream DNS**: 1.1.1.1, 8.8.8.8
2. **Enable DNS Caching**: Reduces external queries
3. **Regular Blocklist Updates**: Keep lists current
4. **Monitor Query Logs**: Identify performance issues
5. **Use SSD Storage**: Faster log access

### Cache Settings
Configure DNS cache in web interface:
1. Go to Settings → DNS
2. Adjust cache size based on network size
3. Set appropriate TTL values

## Security Considerations

### Network Security
1. **Change Default Password**: Use strong admin password
2. **Limit Web Access**: Restrict to local network
3. **Use HTTPS**: Enable SSL for web interface
4. **Regular Updates**: Keep Pi-hole updated

### Access Control
```yaml
# Example: Restrict web interface access
environment:
  - VIRTUAL_HOST=pihole.local
  - PROXY_LOCATION=pihole
```

### API Security
- **Use API Tokens**: Generate secure tokens
- **Limit API Access**: Restrict to trusted IPs
- **Monitor API Usage**: Log API requests

## Backup & Recovery

### Configuration Backup
```bash
# Backup Pi-hole configuration
tar -czf pihole-backup-$(date +%Y%m%d).tar.gz pihole/

# Restore configuration
tar -xzf pihole-backup-20231201.tar.gz
```

### Database Backup
```bash
# Backup Pi-hole database
docker exec pihole sqlite3 /etc/pihole/gravity.db ".backup /backup/gravity.db"

# Restore database
docker exec pihole sqlite3 /etc/pihole/gravity.db ".restore /backup/gravity.db"
```

### Automated Backups
Create backup script:
```bash
#!/bin/bash
DATE=$(date +%Y%m%d)
docker exec pihole pihole -g
tar -czf pihole-backup-$DATE.tar.gz pihole/
```

## Community & Resources

### Official Resources
- **Documentation**: https://docs.pi-hole.net/
- **GitHub**: https://github.com/pi-hole/pi-hole
- **Discord**: https://discord.gg/pihole
- **Reddit**: r/pihole

### Blocklists
- **Steven Black**: https://github.com/StevenBlack/hosts
- **OISD**: https://oisd.nl/
- **Energized**: https://energized.pro/
- **Ultimate**: https://github.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites

### Tools & Add-ons
- **Pi-hole Exporter**: Prometheus metrics
- **Pi-hole Admin**: Mobile app
- **Gravity Sync**: Multi-instance sync
- **Teleporter**: Backup/restore tool

## Conclusion

Pi-hole provides an effective, privacy-focused solution for network-wide ad blocking. With its comprehensive feature set, active community, and minimal resource requirements, it's an essential addition to any homelab network. 