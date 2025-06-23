# Nextcloud

A self-hosted cloud storage solution that provides file sharing, collaboration, and productivity tools. Nextcloud is a complete alternative to Google Drive, Dropbox, and other cloud services.

## Features

- **File Storage & Sharing**: Secure file storage with sharing capabilities
- **Collaboration Tools**: Real-time document editing and collaboration
- **Mobile Apps**: Native mobile applications for all platforms
- **Desktop Sync**: Desktop clients for Windows, macOS, and Linux
- **Calendar & Contacts**: Integrated calendar and contact management
- **Video Calls**: Built-in video conferencing with Talk
- **Office Suite**: Online document editing with Collabora Office
- **App Store**: Extensive ecosystem of third-party applications
- **End-to-End Encryption**: Optional client-side encryption
- **LDAP Integration**: Enterprise user management

## Quick Start

1. **Configure the service**:
   ```bash
   # Edit docker-compose.yml and change default passwords
   nano docker-compose.yml
   ```

2. **Start the service**:
   ```bash
   docker-compose up -d
   ```

3. **Access Nextcloud**:
   - URL: http://localhost:4016
   - Default credentials: admin / admin_password

4. **Initial Setup**:
   - Complete the setup wizard
   - Install recommended apps
   - Configure external storage if needed

## Configuration

### Environment Variables

- `MYSQL_HOST`: Database host (default: nextcloud-db)
- `MYSQL_DATABASE`: Database name (default: nextcloud)
- `MYSQL_USER`: Database user (default: nextcloud)
- `MYSQL_PASSWORD`: Database password (change this!)
- `REDIS_HOST`: Redis host for caching (default: nextcloud-redis)
- `NEXTCLOUD_TRUSTED_DOMAINS`: Trusted domains
- `NEXTCLOUD_ADMIN_USER`: Admin username (default: admin)
- `NEXTCLOUD_ADMIN_PASSWORD`: Admin password (change this!)

### Security Settings

```yaml
environment:
  NEXTCLOUD_TRUSTED_DOMAINS: localhost,your-domain.com
  NEXTCLOUD_ADMIN_PASSWORD: your_secure_password
  MYSQL_PASSWORD: your_secure_db_password
  MYSQL_ROOT_PASSWORD: your_secure_root_password
```

### Volumes

- `./data`: Nextcloud application files
- `./apps`: Custom applications
- `./config`: Configuration files
- `./themes`: Custom themes
- `./uploads`: User uploads and data
- `./db`: MariaDB database data
- `./redis`: Redis cache data

## Usage

### Desktop Client Setup

1. Download Nextcloud Desktop Client
2. Enter server URL: http://localhost:4016
3. Login with your credentials
4. Choose sync folders and settings

### Mobile App Setup

1. Install Nextcloud mobile app
2. Enter server URL: http://localhost:4016
3. Login with your credentials
4. Enable auto-upload for photos/videos

### File Sharing

1. **Internal Sharing**: Share with other Nextcloud users
2. **Public Links**: Create shareable links with passwords
3. **Federated Sharing**: Share with other Nextcloud instances
4. **Group Sharing**: Share with user groups

### Apps & Extensions

Popular apps to install:
- **Calendar**: Event management
- **Contacts**: Contact management
- **Talk**: Video conferencing
- **Collabora Online**: Document editing
- **External Storage**: Connect external storage
- **Gallery**: Photo management
- **Notes**: Note taking
- **Tasks**: Task management

## Maintenance

### Backup

```bash
# Backup Nextcloud data
tar -czf nextcloud-backup-$(date +%Y%m%d).tar.gz data/ config/ uploads/

# Backup database
docker exec nextcloud-db mysqldump -u root -p nextcloud > nextcloud-db-backup.sql

# Backup with encryption
gpg -c nextcloud-backup-$(date +%Y%m%d).tar.gz
```

### Updates

```bash
# Update Nextcloud
docker-compose pull
docker-compose up -d

# Update database schema (if needed)
docker exec nextcloud php occ upgrade
```

### Logs

```bash
# View Nextcloud logs
docker-compose logs -f nextcloud

# View database logs
docker-compose logs -f nextcloud-db

# View Redis logs
docker-compose logs -f nextcloud-redis
```

### Performance Optimization

```bash
# Enable Redis caching
docker exec nextcloud php occ config:system:set redis host --value=nextcloud-redis

# Enable file locking
docker exec nextcloud php occ config:system:set filelocking.enabled --value=true

# Optimize database
docker exec nextcloud php occ db:add-missing-indices
```

## Security Best Practices

### Essential Security

1. **Change Default Passwords**: Update all default passwords
2. **Use HTTPS**: Configure SSL/TLS in production
3. **Enable 2FA**: Require two-factor authentication
4. **Regular Updates**: Keep Nextcloud updated
5. **Backup Strategy**: Regular encrypted backups
6. **Access Control**: Limit admin access

### Production Setup

1. **Reverse Proxy**: Use Nginx Proxy Manager
2. **SSL Certificate**: Obtain and configure SSL
3. **Firewall**: Restrict access to necessary ports
4. **Monitoring**: Monitor access logs and resources
5. **LDAP/AD**: Integrate with enterprise directory

### Performance Tuning

- Enable Redis for caching
- Use external database for large deployments
- Configure proper file locking
- Optimize database queries
- Use SSD storage for better performance

## Troubleshooting

### Common Issues

1. **Can't access Nextcloud**:
   - Check if all containers are running
   - Verify port 4016 is accessible
   - Check logs for errors

2. **Database connection issues**:
   - Ensure MariaDB container is running
   - Check database credentials
   - Verify network connectivity

3. **File upload issues**:
   - Check file permissions
   - Verify upload directory exists
   - Check PHP upload limits

4. **Performance issues**:
   - Enable Redis caching
   - Check system resources
   - Optimize database
   - Monitor disk space

### Performance Optimization

- Use Redis for caching
- Enable file locking
- Optimize database queries
- Use external storage for large files
- Regular database maintenance

## Integration

### External Storage

Nextcloud supports various external storage options:
- **SMB/CIFS**: Windows file shares
- **FTP/SFTP**: FTP servers
- **WebDAV**: WebDAV servers
- **Amazon S3**: Cloud storage
- **Google Drive**: Google Drive integration

### LDAP/Active Directory

Configure LDAP integration for enterprise user management:
1. Install LDAP app
2. Configure LDAP server settings
3. Map user attributes
4. Test connection

## Resources

- [Official Documentation](https://docs.nextcloud.com/)
- [GitHub Repository](https://github.com/nextcloud/server)
- [App Store](https://apps.nextcloud.com/)
- [Community Forum](https://help.nextcloud.com/)
- [Desktop Clients](https://nextcloud.com/install/#install-clients)

## Port

- **Nextcloud Web Interface**: 4016

## Tags

- Cloud Storage
- File Sharing
- Collaboration
- Self-hosted
- Dropbox Alternative
- Google Drive Alternative
- Office Suite
- Calendar
- Contacts 