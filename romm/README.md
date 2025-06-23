# 🎮 ROMM - Retro Open Media Manager

ROMM is a modern, open-source retro game library manager that helps you organize, catalog, and manage your retro game collection with automatic metadata fetching, cover art, and achievements.

## 🌟 Features

- **Multi-Platform Support**: Nintendo, Sega, Sony, Microsoft, and more
- **Automatic Metadata**: Fetches game info from IGDB, MobyGames, and ScreenScraper
- **Cover Art & Screenshots**: High-quality artwork from multiple sources
- **Achievement Tracking**: RetroAchievements integration
- **Save State Management**: Organize and manage save files
- **Library Scanning**: Automatic ROM detection and organization
- **Web Interface**: Modern, responsive web UI
- **API Integration**: Multiple gaming databases for comprehensive data

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Retro game ROMs organized in folders
- API keys for enhanced features (optional but recommended)

### 1. Basic Setup
```bash
# Create required directories
mkdir -p library assets config

# Start the service
docker-compose up -d
```

### 2. Access ROMM
- **URL**: http://localhost:4060
- **Default**: No default credentials (set up during first run)

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `DB_HOST` | Database host | Yes | romm-db |
| `DB_NAME` | Database name | Yes | romm |
| `DB_USER` | Database user | Yes | romm-user |
| `DB_PASSWD` | Database password | Yes | romm-password |
| `ROMM_AUTH_SECRET_KEY` | Authentication secret | Yes | Generate with `openssl rand -hex 32` |
| `IGDB_CLIENT_ID` | IGDB API client ID | No | - |
| `IGDB_CLIENT_SECRET` | IGDB API client secret | No | - |
| `MOBYGAMES_API_KEY` | MobyGames API key | No | - |
| `STEAMGRIDDB_API_KEY` | SteamGridDB API key | No | - |
| `SCREENSCRAPER_USER` | ScreenScraper username | No | - |
| `SCREENSCRAPER_PASSWORD` | ScreenScraper password | No | - |
| `RETROACHIEVEMENTS_API_KEY` | RetroAchievements API key | No | - |

### Volume Mappings

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `./library` | `/romm/library` | Your ROM collection |
| `./assets` | `/romm/assets` | Save states, configs, etc. |
| `./config` | `/romm/config` | ROMM configuration files |

## 📁 Folder Structure

### Library Organization
```
library/
├── Nintendo/
│   ├── Nintendo Entertainment System/
│   ├── Super Nintendo Entertainment System/
│   └── Nintendo 64/
├── Sega/
│   ├── Sega Genesis/
│   ├── Sega CD/
│   └── Sega Dreamcast/
├── Sony/
│   ├── PlayStation/
│   └── PlayStation 2/
└── Microsoft/
    └── Xbox/
```

### Supported Platforms
- **Nintendo**: NES, SNES, N64, GameCube, Wii, Game Boy, GBA, DS, 3DS
- **Sega**: Master System, Genesis, CD, 32X, Saturn, Dreamcast
- **Sony**: PlayStation, PS2, PSP, PS Vita
- **Microsoft**: Xbox, Xbox 360
- **Atari**: 2600, 5200, 7800, Lynx, Jaguar
- **Neo Geo**: AES, MVS, Pocket
- **PC**: DOS, Windows, Linux
- **Arcade**: MAME, FBNeo

## 🔑 API Keys Setup

### 1. IGDB (Internet Game Database)
1. Go to [IGDB API](https://api.igdb.com/)
2. Create a Twitch developer account
3. Register your application
4. Get Client ID and Client Secret

### 2. MobyGames
1. Visit [MobyGames](https://www.mobygames.com/)
2. Create an account
3. Request API access
4. Get your API key

### 3. SteamGridDB
1. Go to [SteamGridDB](https://www.steamgriddb.com/)
2. Create an account
3. Generate API key

### 4. ScreenScraper
1. Visit [ScreenScraper](https://www.screenscraper.fr/)
2. Create an account
3. Use username and password

### 5. RetroAchievements
1. Go to [RetroAchievements](https://retroachievements.org/)
2. Create an account
3. Request API access
4. Get your API key

## 🎯 Usage

### Initial Setup
1. Access ROMM at http://localhost:4060
2. Complete the initial setup wizard
3. Configure your library paths
4. Set up API keys for enhanced features
5. Start scanning your ROM collection

### Managing Games
- **Scan Library**: Automatically detect and catalog ROMs
- **Edit Metadata**: Manually edit game information
- **Download Artwork**: Fetch covers and screenshots
- **Organize Collections**: Create custom playlists
- **Track Progress**: Monitor completion status

### Advanced Features
- **Save State Management**: Organize save files by game
- **Achievement Tracking**: View and track RetroAchievements
- **Library Statistics**: View collection analytics
- **Export Data**: Backup your library data
- **Multi-User Support**: Share library with family

## 🔧 Maintenance

### Backup
```bash
# Backup database
docker exec romm-db mysqldump -u romm-user -p romm > romm_backup.sql

# Backup configuration
cp -r config/ romm_config_backup/
```

### Updates
```bash
# Update ROMM
docker-compose pull
docker-compose up -d
```

### Logs
```bash
# View ROMM logs
docker-compose logs romm

# View database logs
docker-compose logs romm-db
```

## 🛠️ Troubleshooting

### Common Issues

**Service won't start**
- Check if port 4060 is available
- Verify database credentials
- Check Docker logs for errors

**Database connection issues**
- Ensure MariaDB container is healthy
- Verify environment variables
- Check network connectivity

**ROMs not detected**
- Verify folder structure matches supported format
- Check file permissions
- Ensure ROMs are in supported formats

**API keys not working**
- Verify API key format
- Check API service status
- Ensure proper authentication

### Performance Optimization
- **Large Libraries**: Consider SSD storage for better performance
- **Memory Usage**: Monitor RAM usage with large collections
- **Database**: Regular maintenance for optimal performance

## 📚 Documentation

- **Official Docs**: https://docs.romm.app/
- **GitHub**: https://github.com/rommapp/romm
- **Discord**: https://discord.gg/romm
- **API Documentation**: https://docs.romm.app/latest/API/

## 🔗 Related Services

- **Jellyfin** (Port 4000) - Media streaming server
- **Calibre** (Port 8083) - E-book library management
- **Kiwix** (Port 8080) - Offline Wikipedia reader

## 📊 Resource Usage

- **CPU**: Low to Medium (depending on library size)
- **RAM**: 512MB - 2GB
- **Storage**: Varies based on ROM collection size
- **Network**: Low (API calls for metadata)

## 🏆 Best Practices

1. **Organize ROMs**: Use consistent naming and folder structure
2. **Regular Backups**: Backup database and configuration regularly
3. **API Keys**: Use API keys for enhanced metadata and artwork
4. **Updates**: Keep ROMM updated for latest features
5. **Monitoring**: Monitor resource usage with large libraries

---

**Port**: 4060  
**Category**: Media & Entertainment  
**Difficulty**: Medium  
**Maintenance**: Low 