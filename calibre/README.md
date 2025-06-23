# Calibre - E-book Library Management

Calibre is a powerful e-book library management system that allows you to organize, convert, and serve your e-book collection.

## Features

- **E-book Library Management**: Organize and catalog your e-book collection
- **Format Conversion**: Convert between various e-book formats
- **Web Interface**: Access your library through a web browser
- **Metadata Management**: Automatically fetch and manage book metadata
- **Multiple Formats**: Support for EPUB, MOBI, PDF, AZW3, and more
- **User Management**: Multi-user support with different permission levels

## Services

### calibre-web
- **Purpose**: Web-based interface for browsing and reading e-books
- **Port**: 8083
- **URL**: http://localhost:8083
- **Features**: Modern web interface, user management, reading progress

### calibre-server
- **Purpose**: Traditional Calibre server interface
- **Ports**: 8081 (main), 8082 (alternative)
- **URL**: http://localhost:8081
- **Features**: Full Calibre functionality, content server

## Quick Start

1. **Start the services**:
   ```bash
   docker-compose up -d
   ```

2. **Access the web interface**:
   - Calibre Web: http://localhost:8083
   - Calibre Server: http://localhost:8081

3. **Initial setup**:
   - Default admin credentials: `admin` / `admin123`
   - Change default password on first login
   - Add your e-book library directory

## Directory Structure

```
calibre/
├── docker-compose.yml
├── README.md
├── config/         # Configuration files
└── books/          # E-book library directory
```

## Configuration

### Environment Variables
- `PUID`: User ID (default: 1000)
- `PGID`: Group ID (default: 1000)
- `TZ`: Timezone (default: UTC)
- `CALIBRE_DBPATH`: Path to Calibre database
- `CALIBRE_CONFIG_DIRECTORY`: Path to Calibre configuration

### Volumes
- `./config`: Configuration and database files
- `./books`: E-book library directory

### Ports
- `8081`: Calibre server main interface
- `8082`: Calibre server alternative interface
- `8083`: Calibre Web interface

## Usage Examples

### Basic Usage
```bash
# Start all services
docker-compose up -d

# Start only web interface
docker-compose up -d calibre-web

# Start only server
docker-compose up -d calibre-server

# Stop services
docker-compose down
```

### Library Management
```bash
# Add books to library
# Copy e-books to the books/ directory
cp /path/to/your/books/* books/

# Access Calibre Web to organize
open http://localhost:8083

# Use Calibre Server for advanced features
open http://localhost:8081
```

### Content Server
```bash
# Enable content server for external access
# Configure in Calibre Web settings
# Access via: http://your-server:8083
```

## E-book Formats Supported

- **EPUB**: Most common format, widely supported
- **MOBI**: Amazon Kindle format
- **PDF**: Portable Document Format
- **AZW3**: Amazon Kindle format
- **CBR/CBZ**: Comic book formats
- **TXT**: Plain text
- **RTF**: Rich Text Format
- **DOCX**: Microsoft Word format
- **HTML**: Web pages
- **LIT**: Microsoft Reader format

## Metadata Management

### Automatic Metadata Fetching
- ISBN lookup for book information
- Cover art download
- Author and publisher information
- Series and genre classification

### Manual Metadata Editing
- Edit book details through web interface
- Add custom tags and categories
- Manage reading lists and collections

## User Management

### User Roles
- **Admin**: Full access to all features
- **Download**: Can download books
- **Upload**: Can upload books
- **Edit**: Can edit metadata
- **Guest**: Read-only access

### User Creation
1. Access Calibre Web admin panel
2. Go to User Management
3. Create new users with appropriate permissions
4. Set up user-specific libraries if needed

## Backup and Migration

### Backup
```bash
# Backup configuration and database
tar -czf calibre-backup-$(date +%Y%m%d).tar.gz config/

# Backup books library
tar -czf calibre-books-$(date +%Y%m%d).tar.gz books/
```

### Migration
```bash
# Copy existing Calibre library
cp -r /path/to/existing/library books/

# Copy configuration (optional)
cp -r /path/to/existing/config config/

# Restart services
docker-compose restart
```

## Performance Optimization

### Storage
- Use SSD storage for better performance
- Organize books in subdirectories
- Regular cleanup of temporary files

### Memory
- Monitor memory usage with large libraries
- Consider increasing container memory limits
- Use book format optimization

### Network
- Enable content server for local network access
- Use reverse proxy for external access
- Configure proper firewall rules

## Troubleshooting

### Common Issues

1. **Permission errors**:
   ```bash
   # Fix directory permissions
   sudo chown -R 1000:1000 config/ books/
   ```

2. **Port conflicts**:
   - Change port mappings in docker-compose.yml
   - Check if ports are already in use

3. **Database corruption**:
   ```bash
   # Backup and recreate database
   cp config/calibre.db config/calibre.db.backup
   rm config/calibre.db
   docker-compose restart
   ```

4. **Large library performance**:
   - Split large libraries into smaller collections
   - Use SSD storage
   - Increase container resources

### Logs
```bash
# View Calibre Web logs
docker-compose logs -f calibre-web

# View Calibre Server logs
docker-compose logs -f calibre-server
```

## Security Considerations

- **Change Default Passwords**: Update admin password immediately
- **Network Security**: Use reverse proxy with SSL/TLS
- **Access Control**: Limit access to trusted networks
- **Regular Updates**: Keep Calibre images updated
- **Backup Strategy**: Regular backups of library and configuration

## Integration

### Reverse Proxy (Nginx)
```nginx
location /calibre {
    proxy_pass http://localhost:8083;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### External Access
```bash
# Configure for external access
# Update docker-compose.yml with proper network settings
# Use reverse proxy for security
```

## Resources

- **Calibre Official**: https://calibre-ebook.com/
- **Calibre Web**: https://github.com/janeczku/calibre-web
- **LinuxServer.io**: https://docs.linuxserver.io/images/docker-calibre
- **Documentation**: https://manual.calibre-ebook.com/

## License

Calibre is open-source software licensed under the GPL v3. 