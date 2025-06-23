# SearXNG

A privacy-focused meta search engine that aggregates results from multiple search engines without tracking users. SearXNG is a fork of Searx with enhanced features and better maintenance.

## Features

- **Privacy-First**: No user tracking or logging
- **Meta Search**: Aggregates results from multiple search engines
- **Customizable**: Extensive configuration options
- **Multiple Engines**: Support for 80+ search engines
- **Instant Answers**: Quick answers for common queries
- **Image Search**: Search for images across multiple engines
- **Video Search**: Find videos from various sources
- **File Search**: Search for files and documents
- **Map Search**: Location-based search results
- **Translation**: Built-in translation capabilities
- **Proxy Support**: Access blocked search engines

## Quick Start

1. **Start the service**:
   ```bash
   docker-compose up -d
   ```

2. **Access SearXNG**:
   - URL: http://localhost:4054
   - No registration required

3. **Configure (Optional)**:
   - Edit settings.yml for customization
   - Configure search engines
   - Set up themes and preferences

## Configuration

### Environment Variables

- `INSTANCE_NAME`: Name of your SearXNG instance
- `BASE_URL`: Base URL for your instance
- `REDIS_URL`: Redis connection URL for caching

### Configuration File

Create `searxng/settings.yml` for custom configuration:

```yaml
general:
  debug: false
  instance_name: "SearXNG"
  
search:
  safe_search: 0
  autocomplete: "google"
  default_lang: "en"
  
server:
  port: 8080
  bind_address: "0.0.0.0"
  secret_key: "your_secret_key_here"
  base_url: "http://localhost:4054/"
  
ui:
  default_theme: "simple"
  default_locale: "en"
  results_on_new_tab: false
  
redis:
  url: "redis://searxng-redis:6379/0"
```

### Volumes

- `./searxng`: SearXNG configuration directory
- `./redis`: Redis cache data

## Usage

### Basic Search

1. Enter your search query in the search box
2. Choose search category (Web, Images, Videos, etc.)
3. Select preferred search engines
4. Click search or press Enter

### Advanced Features

- **Instant Answers**: Get quick answers for weather, calculations, etc.
- **Filters**: Filter results by time, region, or language
- **Preferences**: Save search preferences and themes
- **Bookmarks**: Bookmark search results
- **Export**: Export search results in various formats

### Search Categories

- **Web**: General web search
- **Images**: Image search across multiple engines
- **Videos**: Video search from various sources
- **News**: News search from multiple sources
- **Maps**: Location and map search
- **Files**: File and document search
- **Music**: Music search and streaming

## Maintenance

### Backup

```bash
# Backup configuration
tar -czf searxng-config-backup-$(date +%Y%m%d).tar.gz searxng/

# Backup Redis data
tar -czf searxng-redis-backup-$(date +%Y%m%d).tar.gz redis/
```

### Updates

```bash
docker-compose pull
docker-compose up -d
```

### Logs

```bash
# View SearXNG logs
docker-compose logs -f searxng

# View Redis logs
docker-compose logs -f searxng-redis
```

### Performance Optimization

- Enable Redis caching for better performance
- Configure appropriate search engines
- Monitor resource usage
- Regular updates for security

## Privacy Features

### No Tracking

- No user accounts or profiles
- No search history storage
- No cookies or tracking scripts
- Anonymous search requests

### Privacy Protection

- Proxy requests through your server
- No data sent to third parties
- Local result processing
- Configurable privacy settings

### Security

- HTTPS support
- Configurable access controls
- Rate limiting options
- Request filtering

## Customization

### Themes

SearXNG supports multiple themes:
- Simple (default)
- Dark
- Light
- Custom CSS themes

### Search Engines

Configure which search engines to use:
- Google, Bing, DuckDuckGo
- Regional search engines
- Specialized engines (academic, news, etc.)

### Localization

- Multiple language support
- Regional search preferences
- Customizable date formats
- Localized instant answers

## Integration

### Browser Integration

1. **Search Engine**: Add SearXNG as default search engine
2. **Bookmarklet**: Create bookmarklet for quick searches
3. **Browser Extension**: Use browser extensions for integration

### API Access

SearXNG provides a REST API for programmatic access:
- JSON API for search results
- Instant answers API
- Autocomplete API

## Troubleshooting

### Common Issues

1. **Search not working**:
   - Check if containers are running
   - Verify network connectivity
   - Check search engine availability

2. **Slow performance**:
   - Enable Redis caching
   - Reduce number of search engines
   - Check system resources

3. **Configuration issues**:
   - Verify settings.yml syntax
   - Check file permissions
   - Restart container after changes

### Performance Optimization

- Use Redis for caching
- Configure appropriate search engines
- Monitor resource usage
- Regular maintenance

## Resources

- [Official Documentation](https://docs.searxng.org/)
- [GitHub Repository](https://github.com/searxng/searxng)
- [Configuration Guide](https://docs.searxng.org/admin/configuration.html)
- [Community Forum](https://github.com/searxng/searxng/discussions)

## Port

- **SearXNG Web Interface**: 4054

## Tags

- Search Engine
- Privacy
- Meta Search
- Self-hosted
- No Tracking
- Search Aggregation
- Instant Answers 