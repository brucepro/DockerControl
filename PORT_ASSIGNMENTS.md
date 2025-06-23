# Port Assignments Summary

## Overview
All services have been assigned ports in the range 4000-9999 to avoid conflicts with system ports and ensure consistent local deployment.

## Port Assignment Strategy
- **4000-4099**: Core homelab services
- **4100-4199**: Development tools
- **4200-4299**: Business applications
- **4300-4399**: Monitoring & analytics
- **4400-4499**: Media & entertainment
- **4500-4599**: Security & networking
- **4600-4699**: Database services
- **4700-4799**: Utility services
- **4800-4899**: Specialized applications
- **4900-4999**: Testing & development
- **5000-9999**: Reserved for future use

## Core Services (4000-4099)

### Media & Entertainment
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Jellyfin | 4000 | http://localhost:4000 | Media streaming server | ✅ Active |
| Immich | 4004 | http://localhost:4004 | Photo backup | ✅ Active |
| Navidrome | 4005 | http://localhost:4005 | Music streaming | ✅ Active |
| ROMM | 4060 | http://localhost:4060 | Retro game library manager | ✅ Active |
| Calibre Web | 8083 | http://localhost:8083 | Ebook library web interface | ✅ Active |
| Calibre Server | 8081 | http://localhost:8081 | Ebook library server | ✅ Active |
| Kiwix | 8080 | http://localhost:8080 | Offline Wikipedia reader | ✅ Active |

### Home Automation
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Home Assistant | 4008 | http://localhost:4008 | Home automation hub | ✅ Active |

### Communication & Collaboration
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Rocket.Chat | 4009 | http://localhost:4009 | Team chat platform | ✅ Active |

### Network & Security
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Pi-hole | 4012 | http://localhost:4012 | DNS ad blocker | ✅ Active |
| AdGuard Home | 4013 | http://localhost:4013 | Advanced DNS filtering | ✅ Active |
| Uptime Kuma | 4014 | http://localhost:4014 | Service monitoring | ✅ Active |
| Nginx Proxy Manager | 80/81/443 | http://localhost:81 | Reverse proxy | ✅ Active |

### Storage & Backup
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Nextcloud | 4016 | http://localhost:4016 | Cloud storage | ✅ Active |
| File Browser | 4017 | http://localhost:4017 | File manager | ✅ Active |
| Duplicati | 4018 | http://localhost:4018 | Backup solution | ✅ Active |

### Monitoring & Analytics
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Grafana | 4020 | http://localhost:4020 | Data visualization | ✅ Active |
| Prometheus | 4021 | http://localhost:4021 | Metrics collection | ✅ Active |
| Netdata | 4022 | http://localhost:4022 | System monitoring | ✅ Active |

### Development & Tools
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Vaultwarden | 4024 | http://localhost:4024 | Password manager | ✅ Active |
| Passbolt | 4025 | http://localhost:4025 | Team password manager | ✅ Active |
| Gitea | 4026 | http://localhost:4026 | Git server | ✅ Active |
| Drone Server | 4027 | http://localhost:4027 | CI/CD platform | ✅ Active |
| Wiki.js | 4028 | http://localhost:4028 | Documentation wiki | ✅ Active |

### Productivity & Management
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Trilium | 4030 | http://localhost:4030 | Note taking | ✅ Active |
| Wekan | 4031 | http://localhost:4031 | Kanban board | ✅ Active |
| FreshRSS | 4032 | http://localhost:4032 | RSS reader | ✅ Active |
| Kimai | 4033 | http://localhost:4033 | Time tracking | ✅ Active |
| InvoicePlane | 4034 | http://localhost:4034 | Invoicing | ✅ Active |
| Mealie | 9000/9001 | http://localhost:9000 | Recipe management | ✅ Active |

### Network Management
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Nmap | 4037 | http://localhost:4037 | Network scanner | ✅ Active |
| Speedtest | 4038 | http://localhost:4038 | Network speed test | ✅ Active |

### Logging & Analysis
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| Graylog | 4040 | http://localhost:4040 | Log management | ✅ Active |

### Utility Services
| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| qBittorrent | 4041 | http://localhost:4041 | Torrent client | ✅ Active |
| SearXNG | 4054 | http://localhost:4054 | Privacy-focused search engine | ✅ Active |

## Web Services (4050-4099)

| Service | Port | URL | Description | Status |
|---------|------|-----|-------------|--------|
| WordPress | 4053 | http://localhost:4053 | Blog platform | ✅ Active |
| n8n | 5678 | http://localhost:5678 | Workflow automation | ✅ Active |
| Puppeteer | 4057 | http://localhost:4057 | Browser automation | ✅ Active |
| Glances | 61208 | http://localhost:61208 | System monitoring | ✅ Active |

## System Services

### Network Services
| Service | Port | Protocol | Description | Status |
|---------|------|----------|-------------|--------|
| WireGuard VPN | 51820 | UDP | VPN server | ✅ Active |
| OpenVPN | 1194 | UDP | VPN server | ✅ Active |
| Unbound DNS | 5335 | TCP/UDP | DNS resolver | ✅ Active |
| Samba | 139/445 | TCP | File sharing | ✅ Active |

### Monitoring Services
| Service | Port | Description | Status |
|---------|------|-------------|--------|
| Glances Grafana | 4059 | Glances dashboards | ✅ Active |

## Service Categories

### Essential Stack (Core Services)
- **Pi-hole** (4012) - Network ad blocking
- **Home Assistant** (4008) - Home automation
- **Jellyfin** (4000) - Media streaming
- **Nextcloud** (4016) - File storage
- **Vaultwarden** (4024) - Password manager

### Development Stack (Development Tools)
- **Gitea** (4026) - Git repositories
- **Drone** (4027) - CI/CD
- **Wiki.js** (4028) - Documentation
- **n8n** (5678) - Workflow automation

### Media Stack (Entertainment)
- **Jellyfin** (4000) - Media server
- **Immich** (4004) - Photo backup
- **Navidrome** (4005) - Music streaming
- **ROMM** (4060) - Retro game library manager
- **qBittorrent** (4041) - Downloads
- **Calibre** (8081/8083) - E-books

### Monitoring Stack (Observability)
- **Grafana** (4020) - Dashboards
- **Prometheus** (4021) - Metrics
- **Uptime Kuma** (4014) - Uptime monitoring
- **Netdata** (4022) - System monitoring
- **Graylog** (4040) - Log management

### Security Stack (Network Security)
- **Pi-hole** (4012) - DNS filtering
- **AdGuard Home** (4013) - Advanced DNS
- **OpenVPN** (1194) - VPN
- **WireGuard** (51820) - Modern VPN
- **Nginx Proxy Manager** (80/81/443) - Reverse proxy

### Productivity Stack (Business Tools)
- **FreshRSS** (4032) - RSS reader
- **SearXNG** (4054) - Search engine
- **Trilium** (4030) - Notes
- **Wekan** (4031) - Kanban
- **Kimai** (4033) - Time tracking
- **InvoicePlane** (4034) - Invoicing

### Communication Stack (Team Collaboration)
- **Rocket.Chat** (4009) - Team chat platform

## Resource Requirements

### Lightweight Services (< 100MB RAM each)
- Pi-hole, Vaultwarden, FreshRSS, SearXNG
- Trilium, Wekan, Kimai, InvoicePlane
- Uptime Kuma, Netdata

### Medium Services (100-500MB RAM each)
- Nextcloud, Home Assistant, Jellyfin
- Gitea, Wiki.js, Grafana, Graylog
- qBittorrent, Calibre

### Heavy Services (> 500MB RAM each)
- Immich, PhotoPrism
- Rocket.Chat, MongoDB
- Elasticsearch, MongoDB
- Multiple database instances

## Port Conflicts Resolved

### Original Conflicts
1. **SearXNG**: Changed from 4053 to 4054 (conflicted with WordPress)
2. **Jellyfin**: Standardized to 4000 (was 8096)
3. **Home Assistant**: Standardized to 4008 (was 8123)
4. **Pi-hole**: Standardized to 4012 (was 8082)
5. **Puppeteer**: Using 4057 (no conflict with Rocket.Chat on 4009)
6. **Rocket.Chat**: Changed from 3000 to 4009 (follows standard port range)

## Security Notes

### Default Passwords to Change
- **Pi-hole**: `adminpassword`
- **Grafana**: `admin` / `admin`
- **Nextcloud**: `admin` / `admin_password`
- **Vaultwarden**: Set during setup
- **Home Assistant**: Set during setup
- **Rocket.Chat**: Set during setup

### SSL/TLS Configuration
- Use Nginx Proxy Manager for SSL termination
- Configure Let's Encrypt certificates
- Enable HTTPS for all services

## Maintenance

### Regular Tasks
- Update all services monthly
- Monitor resource usage
- Backup configurations
- Check security updates
- Review logs for issues

### Backup Strategy
- Configuration files
- Database dumps
- User data
- SSL certificates
- Docker volumes

---

**Last Updated**: December 2024
**Total Services**: 41+
**Status**: All services migrated to individual directories
**Next Review**: Monthly 