# Storage Services

Collection of storage and backup services for data management.

## Services Included

### Samba
- Windows file sharing (SMB/CIFS)
- Network file server
- Cross-platform compatibility
- User authentication

### File Browser
- Web-based file manager
- File upload/download
- Directory sharing
- User management

### Duplicati
- Backup solution
- Encrypted backups
- Multiple storage backends
- Scheduling and automation

### Rclone
- Cloud storage sync
- Multiple provider support
- Encryption
- Mount capabilities

## Quick Start
1. Start storage services:
   ```bash
   docker-compose up -d
   ```
2. Access individual services:
   - File Browser: [http://localhost:4017](http://localhost:4017)
   - Duplicati: [http://localhost:4018](http://localhost:4018)

## Configuration
- Samba config: `./samba/config`
- File Browser: `./filebrowser/config`
- Duplicati: `./duplicati/config`
- Rclone: `./rclone/config`

## Samba Setup
1. Configure users and shares in `./samba/config`
2. Access via network path: `\\localhost\homelab`
3. Default credentials: `admin` / `password`

## File Browser Setup
1. Access web interface
2. Create admin account
3. Configure storage paths
4. Set up user permissions

## Duplicati Setup
1. Access web interface
2. Create backup jobs
3. Configure storage destinations
4. Set up encryption

## Use Cases
- **File Sharing**: Share files across network
- **Backup Management**: Automated backups
- **Cloud Sync**: Sync with cloud storage
- **Web Access**: Access files via web browser

## Security
- Encrypt sensitive data
- Use strong passwords
- Configure proper permissions
- Regular security updates

## Docs
- [Samba](https://www.samba.org/samba/docs/)
- [File Browser](https://filebrowser.org/)
- [Duplicati](https://duplicati.readthedocs.io/)
- [Rclone](https://rclone.org/docs/)

## Tips
- Regular backups of configuration
- Monitor storage usage
- Test restore procedures
- Use encryption for sensitive data 