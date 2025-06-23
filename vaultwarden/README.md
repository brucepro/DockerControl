# Vaultwarden (Bitwarden Server)

A self-hosted password manager compatible with Bitwarden clients. Vaultwarden is a lightweight, secure alternative to the official Bitwarden server.

## Features

- **Password Management**: Store and manage passwords securely
- **Cross-Platform**: Works with all Bitwarden clients
- **End-to-End Encryption**: Your data is encrypted on your server
- **Two-Factor Authentication**: Enhanced security with 2FA
- **Secure Sharing**: Share passwords with family/team members
- **Password Generator**: Generate strong, unique passwords
- **Secure Notes**: Store sensitive information beyond passwords
- **File Attachments**: Attach files to your vault entries

## Quick Start

1. **Configure the service**:
   ```bash
   # Edit docker-compose.yml and set your admin token
   nano docker-compose.yml
   ```

2. **Start the service**:
   ```bash
   docker-compose up -d
   ```

3. **Access Vaultwarden**:
   - URL: http://localhost:4024
   - Create your first account (if signups are enabled)

4. **Connect your Bitwarden client**:
   - Set server URL to: http://localhost:4024
   - Login with your credentials

## Configuration

### Environment Variables

- `DOMAIN`: Your server domain (default: http://localhost:4024)
- `SIGNUPS_ALLOWED`: Allow new user registrations (default: false)
- `WEBSOCKET_ENABLED`: Enable real-time updates (default: true)
- `ADMIN_TOKEN`: Admin panel access token (set this!)
- `SMTP_*`: Email configuration for notifications
- `SHOW_PASSWORD_HINT`: Show password hints (default: false)
- `WEB_VAULT_ENABLED`: Enable web interface (default: true)

### Security Settings

```yaml
environment:
  SIGNUPS_ALLOWED: false  # Disable public signups
  ADMIN_TOKEN: your_secure_token_here
  SHOW_PASSWORD_HINT: false
  WEBSOCKET_ENABLED: true
```

### Volumes

- `./data`: Vaultwarden data directory
- `./web-vault`: Web vault files (optional)

## Usage

### Creating Your First Account

1. Enable signups temporarily:
   ```yaml
   SIGNUPS_ALLOWED: true
   ```

2. Create your account at http://localhost:4024

3. Disable signups again:
   ```yaml
   SIGNUPS_ALLOWED: false
   ```

### Using with Bitwarden Clients

1. **Desktop App**: Download from bitwarden.com
2. **Mobile App**: Available on App Store/Google Play
3. **Browser Extension**: Available for all major browsers
4. **CLI**: Command-line interface available

### Admin Panel

Access the admin panel at: http://localhost:4024/admin

Use the `ADMIN_TOKEN` from your environment variables to access.

## Maintenance

### Backup

```bash
# Backup data directory
tar -czf vaultwarden-backup-$(date +%Y%m%d).tar.gz data/

# Backup with encryption
gpg -c vaultwarden-backup-$(date +%Y%m%d).tar.gz
```

### Updates

```bash
docker-compose pull
docker-compose up -d
```

### Logs

```bash
# View logs
docker-compose logs -f vaultwarden

# Check for errors
docker-compose logs vaultwarden | grep ERROR
```

## Security Best Practices

### Essential Security

1. **Change Admin Token**: Set a strong, unique admin token
2. **Disable Signups**: Prevent unauthorized account creation
3. **Use HTTPS**: Configure SSL/TLS in production
4. **Regular Backups**: Backup your data regularly
5. **Strong Master Password**: Use a very strong master password
6. **Two-Factor Authentication**: Enable 2FA on your account

### Production Setup

1. **Reverse Proxy**: Use Nginx Proxy Manager or similar
2. **SSL Certificate**: Obtain and configure SSL certificate
3. **Firewall**: Restrict access to necessary ports only
4. **Monitoring**: Monitor access logs and system resources
5. **Updates**: Keep Vaultwarden updated regularly

### Backup Strategy

- **Daily**: Automated database backups
- **Weekly**: Full system backup including data directory
- **Monthly**: Test restore procedures
- **Off-site**: Store encrypted backups off-site

## Troubleshooting

### Common Issues

1. **Can't access web vault**:
   - Check if container is running
   - Verify port 4024 is accessible
   - Check logs for errors

2. **Client can't connect**:
   - Verify server URL in client settings
   - Check network connectivity
   - Ensure firewall allows port 4024

3. **Admin panel access denied**:
   - Verify ADMIN_TOKEN is set correctly
   - Check token format and length
   - Restart container after token changes

4. **Performance issues**:
   - Monitor system resources
   - Check database size
   - Consider using external database

### Performance Optimization

- Use external database for large deployments
- Enable Redis for caching
- Regular database maintenance
- Monitor resource usage

## Migration from Bitwarden

1. Export your data from Bitwarden
2. Import into Vaultwarden
3. Update client server settings
4. Test all functionality
5. Update all devices

## Resources

- [Official Documentation](https://github.com/dani-garcia/vaultwarden/wiki)
- [GitHub Repository](https://github.com/dani-garcia/vaultwarden)
- [Bitwarden Clients](https://bitwarden.com/download/)
- [Community Forum](https://community.bitwarden.com/)

## Port

- **Vaultwarden Web Interface**: 4024

## Tags

- Password Manager
- Security
- Self-hosted
- Bitwarden Compatible
- Encryption
- Two-Factor Authentication 