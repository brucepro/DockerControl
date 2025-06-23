# FreshRSS

A free, self-hosted RSS aggregator with a clean interface and powerful features.

## Features

- **Clean Interface**: Modern, responsive design
- **RSS/Atom Support**: Full support for RSS and Atom feeds
- **Mobile Apps**: Native mobile applications available
- **API Support**: REST API for third-party clients
- **Import/Export**: OPML import/export functionality
- **Categories & Tags**: Organize feeds with categories and tags
- **Search**: Full-text search across articles
- **Sharing**: Share articles via email, social media, or custom URLs
- **Extensions**: Plugin system for custom functionality

## Quick Start

1. **Start the service**:
   ```bash
   docker-compose up -d
   ```

2. **Access FreshRSS**:
   - URL: http://localhost:4032
   - Default credentials: admin / password

3. **Initial Setup**:
   - Change the default admin password
   - Add your first RSS feed
   - Configure categories and preferences

## Configuration

### Environment Variables

- `TZ`: Timezone (default: UTC)
- `CRON_MIN`: Feed update frequency (default: every 30 minutes)

### Volumes

- `./data`: FreshRSS data directory
- `./extensions`: Custom extensions
- `./db`: PostgreSQL database data

### Database

FreshRSS uses PostgreSQL for data storage. The database is automatically created with:
- Database: `freshrss`
- User: `freshrss`
- Password: `freshrss_password`

## Usage

### Adding Feeds

1. Click the "+" button in the interface
2. Enter the RSS feed URL
3. Choose a category (optional)
4. Set update frequency
5. Click "Add"

### Mobile Apps

FreshRSS supports various mobile clients:
- **Android**: FreshRSS Android app
- **iOS**: NetNewsWire, Reeder, or other RSS readers
- **Desktop**: Various RSS readers with API support

### API Access

Enable API access in the FreshRSS settings to use with mobile apps or other clients.

## Maintenance

### Backup

```bash
# Backup database
docker exec freshrss-db pg_dump -U freshrss freshrss > backup.sql

# Backup data directory
tar -czf freshrss-data-backup.tar.gz data/
```

### Updates

```bash
docker-compose pull
docker-compose up -d
```

### Logs

```bash
# View logs
docker-compose logs -f freshrss

# View database logs
docker-compose logs -f freshrss-db
```

## Troubleshooting

### Common Issues

1. **Feeds not updating**:
   - Check the cron job is running
   - Verify feed URLs are accessible
   - Check logs for errors

2. **Database connection issues**:
   - Ensure PostgreSQL container is running
   - Check database credentials
   - Verify network connectivity

3. **Performance issues**:
   - Reduce update frequency for large feeds
   - Consider using Redis for caching
   - Monitor database size

### Performance Optimization

- Use Redis for caching (optional)
- Optimize database queries
- Regular database maintenance
- Monitor feed update frequency

## Security

- Change default admin password immediately
- Use HTTPS in production
- Regular security updates
- Monitor access logs
- Consider using a reverse proxy

## Resources

- [Official Documentation](https://freshrss.github.io/FreshRSS/)
- [GitHub Repository](https://github.com/FreshRSS/FreshRSS)
- [Community Forum](https://github.com/FreshRSS/FreshRSS/discussions)
- [Mobile Apps](https://freshrss.github.io/FreshRSS/en/users/02_Mobile.html)

## Port

- **FreshRSS Web Interface**: 4032

## Tags

- RSS Reader
- News Aggregator
- Self-hosted
- Open Source
- Mobile Support 