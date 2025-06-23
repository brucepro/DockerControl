# Home Assistant

Open source home automation that puts local control and privacy first.

## Features
- Home automation hub
- Device integration
- Automation and scripting
- Mobile app support
- Voice control
- Local processing
- Extensive integrations

## Quick Start
1. Start Home Assistant:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:4008](http://localhost:4008)
3. Complete the initial setup

## Configuration
- Config: `./config`
- Add-ons: `./config/addons`
- Custom components: `./config/custom_components`

## Environment Variables
- `TZ`: Timezone (default: UTC)

## Ports
- Web UI: 4008

## Initial Setup
1. Create admin account
2. Set up your home location
3. Discover and add devices
4. Create automations
5. Install add-ons as needed

## Popular Integrations
- Zigbee devices (via Zigbee2MQTT)
- ESP devices (via ESPHome)
- Smart speakers
- Security cameras
- Climate control
- Lighting systems

## Add-ons
- Node-RED for visual automation
- ESPHome for ESP device management
- Zigbee2MQTT for Zigbee devices
- Mosquitto MQTT broker
- File editor
- Terminal

## Docs
- [Official Documentation](https://www.home-assistant.io/docs/)
- [GitHub](https://github.com/home-assistant/core)
- [Integrations](https://www.home-assistant.io/integrations/)
- [Community](https://community.home-assistant.io/)

## Tips
- Start with simple automations
- Use the mobile app for remote access
- Join the community for help
- Regular backups of configuration
- Use YAML for advanced configurations 