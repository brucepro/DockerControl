# OpenVPN

A robust, open-source VPN solution for secure remote access.

## Features
- Secure remote access to your network
- Strong encryption
- Cross-platform clients
- Easy certificate management
- Community and commercial support

## Quick Start
1. Initialize OpenVPN config (first time only):
   ```bash
   docker run -v $PWD/config:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://YOUR_SERVER_IP
   docker run -v $PWD/config:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
   ```
2. Start OpenVPN:
   ```bash
   docker-compose up -d
   ```
3. Add users and export client configs as needed

## Data
- Config: `./config`
- Data: `./data`

## Docs
- [Official Documentation](https://github.com/kylemanna/docker-openvpn/blob/master/docs/README.md)
- [OpenVPN.net](https://openvpn.net/community-resources/how-to/)

## Port
- UDP: 1194 