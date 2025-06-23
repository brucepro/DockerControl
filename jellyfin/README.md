# Jellyfin

A free, open-source media server that puts you in control of your media.

## Features
- Media streaming server
- Web-based interface
- Hardware acceleration support
- DLNA support
- Multiple client apps
- User management
- Transcoding capabilities

## Quick Start
1. Start Jellyfin:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:4000](http://localhost:4000)
3. Complete the initial setup wizard

## Configuration
- Config: `./jellyfin/config`
- Cache: `./jellyfin/cache`
- Logs: `./jellyfin/logs`
- Media: `./media/` (movies, tv, music, photos)

## Hardware Acceleration
For hardware acceleration, use the `jellyfin-hw` service:
```bash
docker-compose up -d jellyfin-hw
```

## Environment Variables
- `JELLYFIN_PublishedServerUrl`: Server URL for clients
- `TZ`: Timezone (default: UTC)
- `JELLYFIN_FFmpeg`: FFmpeg path for transcoding

## Ports
- Web UI: 4000
- DLNA: 8920
- Hardware accelerated: 4001 (web), 8921 (DLNA)

## Docs
- [Official Documentation](https://jellyfin.org/docs/)
- [GitHub](https://github.com/jellyfin/jellyfin)
- [Client Apps](https://jellyfin.org/clients/)

## Tips
- Add media folders to `./media/` directory
- Configure hardware acceleration for better performance
- Set up user accounts for family members
- Enable DLNA for smart TV compatibility 