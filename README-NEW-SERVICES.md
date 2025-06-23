# New Services Added - Based on r/selfhosted Community

Based on your comprehensive list from the r/selfhosted community, I've added several highly recommended services to your homelab setup. Here's what's been added:

## 🆕 New Services Added

### 1. FreshRSS (Port 4032)
**Category**: RSS Reader / News Aggregator
- **Why Added**: Highly recommended for RSS feed management
- **Features**: Clean interface, mobile apps, API support, OPML import/export
- **URL**: http://localhost:4032
- **Default Credentials**: admin / password
- **Use Case**: Replace Google Reader, Feedly, or other RSS services

### 2. Vaultwarden (Port 4024)
**Category**: Password Manager
- **Why Added**: Most popular self-hosted password manager
- **Features**: Bitwarden-compatible, end-to-end encryption, 2FA support
- **URL**: http://localhost:4024
- **Security Note**: Change default admin token and disable signups
- **Use Case**: Replace LastPass, 1Password, or Bitwarden cloud

### 3. Nextcloud (Port 4016)
**Category**: Cloud Storage & Collaboration
- **Why Added**: Essential for file storage and sharing
- **Features**: File sync, calendar, contacts, office suite, mobile apps
- **URL**: http://localhost:4016
- **Default Credentials**: admin / admin_password
- **Use Case**: Replace Google Drive, Dropbox, or OneDrive

### 4. SearXNG (Port 4053)
**Category**: Privacy-Focused Search Engine
- **Why Added**: Privacy-first meta search engine
- **Features**: No tracking, 80+ search engines, instant answers
- **URL**: http://localhost:4053
- **Use Case**: Replace Google Search, Bing, or DuckDuckGo

## 🎯 Services from Your List Still Available

### Already Configured
- **Jellyfin** (8096) - Media streaming server
- **Mealie** (9000) - Recipe management
- **Kiwix** (8080) - Offline Wikipedia reader
- **Calibre** (8081/8083) - E-book library management
- **Home Assistant** (8123) - Home automation
- **Pi-hole** (8082) - DNS ad blocker
- **n8n** (5678) - Workflow automation
- **Glances** (61208) - System monitoring

### Highly Recommended from Your List

#### Media & Entertainment
- **Plex** (32400) - Alternative to Jellyfin
- **PhotoPrism** (2342) - Photo management
- **Immich** (4001) - Photo backup
- **Navidrome** (4000) - Music streaming

#### Development & Tools
- **Gitea** (4026) - Git repository management
- **Wiki.js** (4028) - Documentation wiki
- **Grafana** (4020) - Monitoring dashboards
- **Portainer** (9000) - Docker management

#### Network & Security
- **AdGuard Home** (4013) - Advanced DNS filtering
- **Uptime Kuma** (3001) - Service monitoring
- **Nginx Proxy Manager** (4015) - Reverse proxy
- **WireGuard** (51820) - VPN server

#### Productivity
- **Trilium** (4030) - Note taking
- **Wekan** (4031) - Kanban board
- **Kimai** (4033) - Time tracking
- **InvoicePlane** (4034) - Invoicing

#### Media Management
- **Radarr** (4043) - Movie management
- **Sonarr** (4044) - TV show management
- **Overseerr** (4048) - Media requests
- **qBittorrent** (4041) - Torrent client

## 🚀 Quick Start Guide

### 1. Start Essential Services
```bash
# Start core services
cd freshrss && docker-compose up -d
cd ../vaultwarden && docker-compose up -d
cd ../nextcloud && docker-compose up -d
cd ../searxng && docker-compose up -d
```

### 2. Initial Configuration

#### FreshRSS
1. Access http://localhost:4032
2. Login with admin / password
3. Change default password
4. Add your first RSS feed

#### Vaultwarden
1. Edit docker-compose.yml and set ADMIN_TOKEN
2. Access http://localhost:4024
3. Enable signups temporarily to create account
4. Disable signups after account creation

#### Nextcloud
1. Access http://localhost:4016
2. Complete setup wizard
3. Install recommended apps
4. Configure desktop/mobile clients

#### SearXNG
1. Access http://localhost:4053
2. No registration required
3. Start searching immediately
4. Configure as default search engine

## 🔧 Integration Tips

### Browser Integration
- **SearXNG**: Add as default search engine in browser
- **FreshRSS**: Use browser extensions for quick access
- **Vaultwarden**: Install Bitwarden browser extension
- **Nextcloud**: Use desktop client for file sync

### Mobile Apps
- **FreshRSS**: Official mobile app available
- **Vaultwarden**: Use Bitwarden mobile app
- **Nextcloud**: Official mobile app with auto-upload
- **SearXNG**: Use mobile browser or create home screen shortcut

### Security Considerations
1. **Change all default passwords**
2. **Use HTTPS in production** (Nginx Proxy Manager)
3. **Enable 2FA where available**
4. **Regular backups** of all data
5. **Monitor access logs**

## 📊 Resource Usage

### Lightweight Services (Good for N100)
- **FreshRSS**: ~50MB RAM, minimal CPU
- **SearXNG**: ~100MB RAM, moderate CPU
- **Vaultwarden**: ~50MB RAM, minimal CPU

### Medium Services
- **Nextcloud**: ~200-500MB RAM, moderate CPU
- **Home Assistant**: ~200-400MB RAM, moderate CPU
- **Jellyfin**: ~200-800MB RAM, high CPU (transcoding)

### Heavy Services (Consider carefully)
- **Plex**: ~500MB-2GB RAM, high CPU
- **PhotoPrism**: ~500MB-1GB RAM, high CPU
- **Immich**: ~500MB-1GB RAM, moderate CPU

## 🎯 Recommended Next Steps

### Phase 1: Core Services
1. **Pi-hole** - Network ad blocking
2. **Vaultwarden** - Password management
3. **Nextcloud** - File storage
4. **FreshRSS** - News aggregation

### Phase 2: Media & Entertainment
1. **Jellyfin** - Media streaming
2. **Radarr/Sonarr** - Media management
3. **qBittorrent** - Download management
4. **Overseerr** - Media requests

### Phase 3: Monitoring & Automation
1. **Home Assistant** - Home automation
2. **Grafana** - Monitoring dashboards
3. **Uptime Kuma** - Service monitoring
4. **n8n** - Workflow automation

### Phase 4: Development & Tools
1. **Gitea** - Git repositories
2. **Wiki.js** - Documentation
3. **SearXNG** - Search engine
4. **Portainer** - Docker management

## 🔗 Useful Resources

### Community
- [r/selfhosted](https://reddit.com/r/selfhosted) - Main community
- [Awesome Selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted) - Comprehensive list
- [Selfhosted Show](https://selfhosted.show/) - Podcast about self-hosting

### Documentation
- Each service has detailed README files
- Official documentation links provided
- Community forums and Discord servers

### Tools & Scripts
- **start-all-services.sh** - Start all services
- **update-all-services.sh** - Update all services
- **maintenance.sh** - Maintenance tasks
- **quick-access.sh** - Quick service access

## 📈 Performance Optimization

### For N100 Mini PC (16GB RAM)
1. **Start with lightweight services first**
2. **Monitor resource usage** with Glances
3. **Use external storage** for media files
4. **Enable caching** where possible
5. **Regular maintenance** and cleanup

### Scaling Up
1. **Add more RAM** if needed
2. **Use SSD storage** for better performance
3. **Consider dedicated media server** for heavy transcoding
4. **Implement proper backup strategy**

---

**Total New Services Added**: 4
**Total Services Available**: 150+
**Port Range**: 4000-9999
**Status**: Ready for deployment 