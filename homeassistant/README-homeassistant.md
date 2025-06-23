# Home Assistant - Home Automation Hub

## Why Home Assistant?

**Home Assistant** was chosen as the home automation solution because it's:

- **100% Local**: No cloud dependencies, complete privacy
- **Open Source**: Full control over your automation system
- **Extremely Flexible**: Supports 2000+ integrations
- **Community-Driven**: Massive ecosystem of add-ons and custom components
- **Privacy-Focused**: All data stays on your network
- **Future-Proof**: Regular updates and new integrations

## What Home Assistant Does

Home Assistant is a home automation hub that:

- **Centralizes Control**: Manage all smart devices from one interface
- **Creates Automations**: Automate daily tasks and routines
- **Integrates Devices**: Connect devices from different manufacturers
- **Provides Dashboards**: Custom interfaces for different users
- **Enables Voice Control**: Integrate with voice assistants
- **Monitors Your Home**: Track sensors, cameras, and devices
- **Saves Energy**: Optimize usage with smart scheduling

## Quick Start

1. **Create configuration directory**:
```bash
mkdir -p homeassistant/config
```

2. **Start Home Assistant**:
```bash
docker-compose -f docker-compose-homeassistant.yml up homeassistant -d
```

3. **Access the web interface** at `http://localhost:8123`

4. **Complete initial setup**:
   - Create admin account
   - Set location and timezone
   - Add your first device

## Core Services

### Home Assistant Core
The main automation engine with web interface.

### MQTT Broker (Mosquitto)
Message broker for IoT device communication:
- **Port**: 1883 (MQTT), 9001 (WebSocket)
- **Purpose**: Device-to-device communication
- **Required for**: Zigbee2MQTT, ESPHome, many IoT devices

### Zigbee2MQTT
Zigbee device management:
- **Port**: 8080
- **Purpose**: Connect Zigbee devices to Home Assistant
- **Hardware**: Requires Zigbee USB stick (CC2531, CC2652, etc.)

### ESPHome
ESP8266/ESP32 device management:
- **Port**: 6052
- **Purpose**: Create custom IoT devices
- **Features**: Over-the-air updates, YAML configuration

### Node-RED
Visual automation builder:
- **Port**: 1880
- **Purpose**: Create complex automation flows
- **Features**: Drag-and-drop interface, JavaScript support

### InfluxDB + Grafana
Data storage and visualization:
- **InfluxDB Port**: 8086
- **Grafana Port**: 3000
- **Purpose**: Long-term data storage and dashboards

## Device Integration

### Smart Plugs & Switches
```yaml
# Example: TP-Link Kasa switch
switch:
  - platform: tplink
    host: 192.168.1.100
    name: Living Room Light
```

### Sensors
```yaml
# Example: Temperature sensor
sensor:
  - platform: mqtt
    name: "Living Room Temperature"
    state_topic: "home/livingroom/temperature"
    unit_of_measurement: "°C"
```

### Cameras
```yaml
# Example: IP camera
camera:
  - platform: generic
    name: Front Door Camera
    stream_source: http://192.168.1.200:8080/video
```

### Voice Assistants
```yaml
# Example: Google Assistant integration
google_assistant:
  project_id: your-project-id
  service_account: !include service_account.json
```

## Automation Examples

### Morning Routine
```yaml
automation:
  - alias: "Morning Routine"
    trigger:
      platform: time
      at: "07:00:00"
    action:
      - service: switch.turn_on
        target:
          entity_id: switch.living_room_lights
      - service: media_player.play
        target:
          entity_id: media_player.kitchen_speaker
      - service: climate.set_temperature
        target:
          entity_id: climate.thermostat
        data:
          temperature: 22
```

### Motion Detection
```yaml
automation:
  - alias: "Motion Detected"
    trigger:
      platform: state
      entity_id: binary_sensor.motion_sensor
      to: "on"
    action:
      - service: camera.snapshot
        target:
          entity_id: camera.front_door
      - service: notify.mobile_app
        data:
          message: "Motion detected at front door"
          title: "Security Alert"
```

### Energy Management
```yaml
automation:
  - alias: "Turn off lights when no motion"
    trigger:
      platform: state
      entity_id: binary_sensor.living_room_motion
      to: "off"
      for: "00:05:00"
    action:
      - service: switch.turn_off
        target:
          entity_id: switch.living_room_lights
```

## Advanced Configuration

### Custom Dashboards
Create personalized interfaces for different users:

```yaml
# Example: Mobile dashboard
views:
  - title: Mobile
    path: mobile
    icon: mdi:cellphone
    badges: []
    cards:
      - type: entities
        title: Quick Controls
        entities:
          - entity: switch.living_room_lights
          - entity: switch.kitchen_lights
          - entity: climate.thermostat
```

### Custom Components
Add functionality not available in core:

```yaml
# Example: Custom sensor
sensor:
  - platform: command_line
    name: "System Load"
    command: "uptime | awk '{print $10}' | sed 's/,//'"
    unit_of_measurement: "load"
    scan_interval: 30
```

### Templates
Create dynamic values and conditions:

```yaml
# Example: Template sensor
sensor:
  - platform: template
    sensors:
      average_temperature:
        friendly_name: "Average Temperature"
        unit_of_measurement: "°C"
        value_template: >
          {% set temps = states | selectattr('entity_id', 'match', 'sensor.*temperature') | list %}
          {% if temps | length > 0 %}
            {{ (temps | map(attribute='state') | map('float') | sum) / (temps | length) | round(1) }}
          {% else %}
            {{ none }}
          {% endif %}
```

## Security Best Practices

### Network Security
1. **Isolate IoT devices** on separate VLAN
2. **Use strong passwords** for all accounts
3. **Enable SSL/TLS** for external access
4. **Regular updates** of Home Assistant and add-ons

### Access Control
```yaml
# Example: User permissions
homeassistant:
  auth_providers:
    - type: homeassistant
    - type: trusted_networks
      trusted_networks:
        - 192.168.1.0/24
```

### API Security
```yaml
# Example: Secure API access
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.1.0/24
  ssl_certificate: /ssl/cert.pem
  ssl_key: /ssl/key.pem
```

## Performance Optimization

### Database Management
```yaml
# Example: Optimize database
recorder:
  purge_keep_days: 30
  commit_interval: 1
  auto_purge: true
  auto_repack: true
```

### Resource Usage
- **CPU**: 2-4 cores recommended
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: SSD for better performance
- **Network**: Stable connection for device communication

## Troubleshooting

### Common Issues

1. **Devices Not Connecting**:
   - Check network connectivity
   - Verify device compatibility
   - Review integration documentation

2. **Automations Not Working**:
   - Check trigger conditions
   - Verify entity states
   - Review automation logs

3. **Performance Issues**:
   - Optimize database settings
   - Reduce sensor polling frequency
   - Monitor system resources

### Logs
View Home Assistant logs:
```bash
docker-compose -f docker-compose-homeassistant.yml logs homeassistant
```

### Debug Mode
Enable debug logging:
```yaml
logger:
  default: info
  logs:
    homeassistant.core: debug
    homeassistant.components.automation: debug
```

## Integration Examples

### Smart Home Ecosystems
- **Philips Hue**: Lights and sensors
- **IKEA Tradfri**: Affordable Zigbee devices
- **Xiaomi/Aqara**: Cost-effective sensors
- **Tuya/Smart Life**: WiFi devices
- **Z-Wave**: Reliable mesh network

### Voice Assistants
- **Google Assistant**: Natural language control
- **Amazon Alexa**: Voice commands
- **Apple Siri**: iOS integration
- **Local Voice**: Rhasspy, Mycroft

### Monitoring & Analytics
- **Grafana**: Custom dashboards
- **InfluxDB**: Time-series data
- **Prometheus**: Metrics collection
- **Node-RED**: Advanced automation

## Backup & Recovery

### Configuration Backup
```bash
# Backup configuration
tar -czf homeassistant-backup-$(date +%Y%m%d).tar.gz homeassistant/

# Restore configuration
tar -xzf homeassistant-backup-20231201.tar.gz
```

### Database Backup
```bash
# Backup SQLite database
cp homeassistant/config/home-assistant_v2.db backup/
```

### Snapshot Backup
Use Home Assistant's built-in snapshot feature:
1. Go to Settings → System → Backups
2. Create full snapshot
3. Download to external storage

## Community & Resources

### Official Resources
- **Documentation**: https://www.home-assistant.io/docs/
- **Community Forum**: https://community.home-assistant.io/
- **GitHub**: https://github.com/home-assistant/core
- **Discord**: https://discord.gg/homeassistant

### Add-ons & Integrations
- **HACS**: Home Assistant Community Store
- **Custom Cards**: UI enhancements
- **Custom Components**: Additional integrations
- **Blueprints**: Pre-made automations

### Learning Resources
- **YouTube Channels**: DrZzs, The Hook Up, Everything Smart Home
- **Blogs**: Home Assistant Blog, Smart Home Solver
- **Books**: "Home Assistant: Beginner to Pro"

## Conclusion

Home Assistant provides a powerful, flexible, and privacy-focused home automation platform perfect for any homelab. With its extensive ecosystem, active community, and local-first approach, it's the ideal choice for creating a truly smart home that you control completely. 