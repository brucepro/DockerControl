# Navidrome

A lightweight, self-hosted music server and streamer compatible with Subsonic clients.

## Features
- Web-based music streaming
- Subsonic API compatible (works with many mobile/desktop apps)
- Fast library scanning
- Modern, responsive UI
- Playlists, favorites, and smart playlists
- Multi-user support
- Low resource usage

## Quick Start
1. Place your music in the `music` directory.
2. Start Navidrome:
   ```bash
   docker-compose up -d
   ```
3. Access the web UI at [http://localhost:4005](http://localhost:4005)
4. Default login: `admin` / `admin` (change password after first login)

## Configuration
- Music directory: `./music`
- Data directory: `./data`
- Change scan schedule and other options in `docker-compose.yml` or via the web UI.

## Mobile Apps
- Compatible with Subsonic apps like DSub, Ultrasonic, Substreamer, etc.

## Docs
- [Official Documentation](https://www.navidrome.org/docs/)
- [GitHub](https://github.com/navidrome/navidrome)

## Port
- Web UI: 4005 