# Samba

A SMB/CIFS file server for sharing files across your network.

## Features
- Windows file sharing compatibility
- User authentication
- Network file sharing
- Cross-platform access

## Quick Start
1. Start Samba:
   ```bash
   docker-compose up -d
   ```
2. Access via network path: `\\localhost\homelab`
3. Default credentials: `admin` / `password`

## Configuration
- Config: `./config`
- Shared storage: `./storage`

## Docs
- [Official Documentation](https://www.samba.org/samba/docs/)
- [GitHub](https://github.com/dperson/samba)

## Port
- SMB: 139, 445 