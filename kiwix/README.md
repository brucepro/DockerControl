# Kiwix - Offline Wikipedia Reader

Kiwix is a free and open-source offline web browser that allows you to browse Wikipedia and other content without an internet connection.

## Features

- **Offline Wikipedia**: Browse Wikipedia articles without internet
- **Multiple Content Types**: Supports Wikipedia, Wikibooks, Wikivoyage, and more
- **Cross-Platform**: Works on desktop, mobile, and web browsers
- **Lightweight**: Efficient compression and storage
- **Search Functionality**: Full-text search within offline content

## Services

### kiwix-serve
- **Purpose**: Serves the offline content via web interface
- **Port**: 8080
- **URL**: http://localhost:8080
- **Features**: Web-based interface for browsing offline content

### kiwix-tools
- **Purpose**: Management tools for downloading and managing content
- **Usage**: One-time container for downloading content
- **Features**: Content download, library management, content conversion

## Quick Start

1. **Start the service**:
   ```bash
   docker-compose up -d kiwix-serve
   ```

2. **Access the web interface**:
   - Open http://localhost:8080 in your browser

3. **Download content** (optional):
   ```bash
   # Download Wikipedia content
   docker-compose run --rm kiwix-tools kiwix-manage /library/library.xml add /downloads/wikipedia_en_all_maxi_2023-12.zim
   
   # Download other content types
   docker-compose run --rm kiwix-tools kiwix-manage /library/library.xml add /downloads/wikibooks_en_all_maxi_2023-12.zim
   ```

## Directory Structure

```
kiwix/
├── docker-compose.yml
├── README.md
├── data/           # Content storage
├── library/        # Library metadata
└── downloads/      # Downloaded content files
```

## Configuration

### Environment Variables
- `TZ`: Timezone (default: UTC)

### Volumes
- `./data`: Content storage directory
- `./library`: Library metadata directory
- `./downloads`: Downloads directory for content files

### Ports
- `8080`: Web interface port

## Content Management

### Downloading Content

1. **Find content URLs**:
   - Visit https://download.kiwix.org/zim/
   - Choose content type and language
   - Download .zim files

2. **Add content to library**:
   ```bash
   docker-compose run --rm kiwix-tools kiwix-manage /library/library.xml add /downloads/your_content.zim
   ```

3. **List available content**:
   ```bash
   docker-compose run --rm kiwix-tools kiwix-manage /library/library.xml list
   ```

### Popular Content Types

- **Wikipedia**: `wikipedia_en_all_maxi_2023-12.zim`
- **Wikibooks**: `wikibooks_en_all_maxi_2023-12.zim`
- **Wikivoyage**: `wikivoyage_en_all_maxi_2023-12.zim`
- **Project Gutenberg**: `gutenberg_en_all_2023-12.zim`
- **Stack Overflow**: `stack_exchange_en_all_2023-12.zim`

## Usage Examples

### Basic Usage
```bash
# Start the service
docker-compose up -d

# Access web interface
open http://localhost:8080

# Stop the service
docker-compose down
```

### Content Management
```bash
# Download Wikipedia
wget https://download.kiwix.org/zim/wikipedia_en_all_maxi_2023-12.zim -O downloads/wikipedia_en_all_maxi_2023-12.zim

# Add to library
docker-compose run --rm kiwix-tools kiwix-manage /library/library.xml add /downloads/wikipedia_en_all_maxi_2023-12.zim

# List content
docker-compose run --rm kiwix-tools kiwix-manage /library/library.xml list
```

### Advanced Configuration
```bash
# Custom port
docker-compose up -d -p 9090:8080

# Custom data directory
docker-compose up -d -v /path/to/kiwix-data:/data
```

## Troubleshooting

### Common Issues

1. **No content available**:
   - Download .zim files to the downloads directory
   - Add them to the library using kiwix-manage
   - Restart the kiwix-serve container

2. **Port conflicts**:
   - Change the port mapping in docker-compose.yml
   - Check if port 8080 is already in use

3. **Large file downloads**:
   - Use a download manager for large .zim files
   - Consider using torrent downloads for large files
   - Ensure sufficient disk space

### Logs
```bash
# View service logs
docker-compose logs -f kiwix-serve

# View tools logs
docker-compose logs kiwix-tools
```

## Performance Tips

1. **Storage**: Use SSD storage for better performance
2. **Memory**: Allocate sufficient RAM for large content files
3. **Network**: Use local network for faster content sharing
4. **Content Selection**: Choose appropriate content size for your needs

## Security Considerations

- **Access Control**: Consider using reverse proxy with authentication
- **Network Security**: Limit access to trusted networks
- **Content Verification**: Verify downloaded content integrity
- **Updates**: Keep the Kiwix images updated

## Backup and Migration

### Backup
```bash
# Backup library and data
tar -czf kiwix-backup-$(date +%Y%m%d).tar.gz data/ library/
```

### Migration
```bash
# Copy data to new location
cp -r data/ library/ /new/location/

# Update docker-compose.yml with new paths
# Restart the service
```

## Resources

- **Official Website**: https://www.kiwix.org/
- **Content Downloads**: https://download.kiwix.org/
- **Documentation**: https://wiki.kiwix.org/
- **GitHub**: https://github.com/kiwix/kiwix-tools

## License

Kiwix is open-source software licensed under the GPL v3. 