# Jellyfin Media Server

## Why Jellyfin?

**Jellyfin** was chosen as the media server solution for this homelab because it's:

- **100% Free & Open Source**: No licensing fees or premium features
- **Self-Hosted**: Complete control over your media and data
- **Cross-Platform**: Works on any device with a web browser
- **Feature-Rich**: Includes transcoding, metadata scraping, user management
- **Privacy-Focused**: No tracking or external dependencies
- **Active Development**: Large community and regular updates

## What Jellyfin Does

Jellyfin is a media server that allows you to:

- **Stream Media**: Movies, TV shows, music, and photos from your server
- **Automatic Metadata**: Scrape movie/show information, posters, and descriptions
- **Transcoding**: Convert media formats on-the-fly for different devices
- **User Management**: Create multiple user accounts with different permissions
- **DLNA Support**: Stream to smart TVs and other DLNA devices
- **Mobile Apps**: Official apps for Android and iOS
- **Web Interface**: Access your media from any web browser

## Quick Start

1. **Create media directories**:
```bash
mkdir -p media/{movies,tv,music,photos}
mkdir -p jellyfin/{config,cache,logs}
```

2. **Add your media files** to the appropriate directories

3. **Start Jellyfin**:
```bash
docker-compose -f docker-compose-jellyfin.yml up -d
```

4. **Access the web interface** at `http://localhost:8096`

5. **Complete the initial setup**:
   - Create admin account
   - Add media libraries
   - Configure metadata providers

## Configuration

### Media Library Structure
```
media/
├── movies/
│   ├── Movie Title (2023)/
│   │   ├── Movie Title (2023).mkv
│   │   └── poster.jpg
├── tv/
│   └── Show Name/
│       ├── Season 01/
│       │   ├── Show Name S01E01.mkv
│       │   └── Show Name S01E02.mkv
├── music/
│   └── Artist/
│       └── Album/
│           └── 01 - Song.mp3
└── photos/
    └── 2023/
        └── vacation.jpg
```

### Hardware Acceleration
For better performance, enable hardware acceleration:

1. **Check GPU support**:
```bash
ls /dev/dri
```

2. **Use the hardware-accelerated version**:
```bash
docker-compose -f docker-compose-jellyfin.yml up jellyfin-hw -d
```

### Environment Variables
- `JELLYFIN_PublishedServerUrl`: External URL for remote access
- `TZ`: Timezone for proper scheduling
- `JELLYFIN_FFmpeg`: Path to FFmpeg for transcoding

## Features & Capabilities

### Media Management
- **Automatic Organization**: Jellyfin can organize your media automatically
- **Metadata Scraping**: Pulls movie/show info from online databases
- **Artwork**: Downloads posters, backgrounds, and screenshots
- **Subtitles**: Automatic subtitle downloading and management

### Streaming & Transcoding
- **Direct Play**: Stream without conversion when possible
- **Transcoding**: Convert media for incompatible devices
- **Quality Settings**: Adjust streaming quality per device
- **Bandwidth Management**: Limit bandwidth usage

### User Management
- **Multiple Users**: Create accounts for family members
- **Parental Controls**: Restrict content by rating
- **Watch History**: Track what each user has watched
- **Favorites**: Allow users to mark favorite content

### Remote Access
- **Web Interface**: Access from any device with a browser
- **Mobile Apps**: Official apps for Android and iOS
- **DLNA**: Stream to smart TVs and media players
- **API**: Integrate with other applications

## Advanced Configuration

### Custom FFmpeg Path
If you need custom FFmpeg builds:
```yaml
environment:
  - JELLYFIN_FFmpeg=/path/to/custom/ffmpeg
```

### Reverse Proxy Setup
For external access, configure your reverse proxy:
```nginx
location /jellyfin {
    proxy_pass http://localhost:8096;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### Backup Configuration
Backup your Jellyfin data:
```bash
# Backup configuration
tar -czf jellyfin-backup-$(date +%Y%m%d).tar.gz jellyfin/

# Restore configuration
tar -xzf jellyfin-backup-20231201.tar.gz
```

## Troubleshooting

### Common Issues

1. **Permission Errors**:
```bash
chown -R 1000:1000 jellyfin/
chown -R 1000:1000 media/
```

2. **Transcoding Issues**:
- Check FFmpeg installation
- Verify hardware acceleration support
- Review transcoding logs

3. **Metadata Not Loading**:
- Check internet connectivity
- Verify metadata provider settings
- Review library scan logs

4. **Performance Issues**:
- Enable hardware acceleration
- Adjust transcoding settings
- Monitor system resources

### Logs
View Jellyfin logs:
```bash
docker-compose -f docker-compose-jellyfin.yml logs jellyfin
```

### Database Maintenance
Jellyfin uses SQLite for its database. Regular maintenance:
```bash
# Access Jellyfin container
docker exec -it jellyfin bash

# Optimize database
sqlite3 /config/data/jellyfin.db "VACUUM;"
```

## Security Considerations

1. **Network Security**:
   - Use reverse proxy with SSL
   - Restrict access to trusted networks
   - Regular security updates

2. **User Accounts**:
   - Use strong passwords
   - Enable two-factor authentication
   - Regular password changes

3. **Media Access**:
   - Read-only mounts for media
   - Proper file permissions
   - Regular backups

## Integration with Other Services

### Download Integration
Connect with download managers:
- **qBittorrent**: Download directly to media folders
- **Radarr/Sonarr**: Automatic movie/TV show management
- **Lidarr**: Music download automation

### Monitoring
Monitor Jellyfin with:
- **Grafana**: Performance dashboards
- **Prometheus**: Metrics collection
- **Uptime Kuma**: Service monitoring

## Performance Optimization

### Hardware Requirements
- **CPU**: Multi-core for transcoding
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: Fast storage for transcoding cache
- **Network**: Gigabit Ethernet for streaming

### Optimization Tips
1. **Use Hardware Acceleration**: Reduces CPU usage
2. **Optimize Media Formats**: Use compatible formats
3. **Adjust Transcoding Settings**: Balance quality vs performance
4. **Monitor Resource Usage**: Use monitoring tools
5. **Regular Maintenance**: Clean cache and optimize database

## Support & Resources

- **Official Documentation**: https://jellyfin.org/docs/
- **Community Forum**: https://forum.jellyfin.org/
- **GitHub Repository**: https://github.com/jellyfin/jellyfin
- **Discord Server**: https://discord.gg/jellyfin

## Migration from Other Services

### From Plex
1. Export your Plex library
2. Install Jellyfin
3. Point to same media directories
4. Re-scan libraries for metadata

### From Emby
1. Jellyfin is a fork of Emby
2. Most configurations are compatible
3. May need to re-scan libraries

## Conclusion

Jellyfin provides a powerful, free, and privacy-focused media server solution perfect for any homelab. With its extensive feature set, active development, and strong community support, it's an excellent choice for managing and streaming your media collection. 