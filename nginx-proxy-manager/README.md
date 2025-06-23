# Nginx Proxy Manager

A beautiful web interface for managing Nginx proxy hosts with SSL support.

## Features
- Web-based Nginx proxy management
- SSL certificate management
- Let's Encrypt integration
- Access lists
- Redirection hosts
- 404 hosts

## Quick Start
1. Start Nginx Proxy Manager:
   ```bash
   docker-compose up -d
   ```
2. Access the admin panel at [http://localhost:81](http://localhost:81)
3. Default credentials: `admin@example.com` / `changeme`

## Configuration
- App data: `./data`
- SSL certificates: `./letsencrypt`
- Database: `./mysql`

## Docs
- [Official Documentation](https://nginxproxymanager.com/)
- [GitHub](https://github.com/jc21/nginx-proxy-manager)

## Port
- HTTP: 80
- Admin: 81
- HTTPS: 443 