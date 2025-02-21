# Advanced MikroTik Firewall

This document contains a professional-grade firewall configuration for MikroTik routers, designed to enhance network security, optimize traffic management, and protect against modern cyber threats. The configuration is tailored for enterprise environments, ensuring robust protection while maintaining high performance and scalability.

__It is advised to use the hardening script beforehand to ensure maximum security. It is available from the link below.__
[MikroTik-Hardening](https://github.com/hsm1391/MikroTik-Hardening)

---

## Table of Contents
1. [Introduction](#introduction)
2. [Best Practices](#best-practices)
   - [Update RouterOS](#update-routeros)
   - [Create Interface List](#create-interface-list)
   - [Change Default Credentials](#change-default-credentials)
   - [Disable Unused Services](#disable-unused-services)
   - [Secure Winbox Access](#secure-winbox-access)
   - [Enable Firewall](#enable-firewall)
   - [Use Strong Encryption](#use-strong-encryption)
   - [Disable Unused Interfaces](#disable-unused-interfaces)
   - [Disable VPN Servers](#disable-vpn-servers)
   - [Enable MAC Address Filtering](#enable-mac-address-filtering)
   - [Disable UPnP](#disable-upnp)
   - [Regular Backups](#regular-backups)
   - [Monitor and Audit](#monitor-and-audit)
3. [Contributing](#contributing)


---


Table of Contents

    Key Features

    Prerequisites

    Installation and Setup

        Backup Existing Configuration

        Upload Configuration Script

        Apply Configuration

        Verify Configuration

    Configuration Overview

        Firewall Filter Rules

        Address Lists

        GeoIP Filtering

        DoS/DDoS Protection

        VLAN Security

    Logging and Monitoring

        Enable Logging for Specific Rules

        View Logs

    Customization

    Best Practices

    Troubleshooting

    Contributing

    License

    Disclaimer

Key Features

    Stateful Packet Inspection (SPI): Ensures only legitimate and authorized traffic is permitted.

    Comprehensive Access Control: Granular control over inbound, outbound, and internal traffic.

    DoS/DDoS Mitigation: Protects against denial-of-service and distributed denial-of-service attacks.

    GeoIP Filtering: Restricts traffic based on geographic regions to minimize exposure to high-risk areas.

    VLAN Segmentation: Secures inter-VLAN communication and enforces isolation where necessary.

    Advanced Logging and Monitoring: Detailed logging for auditing, troubleshooting, and compliance.

    Customizable Ruleset: Easily adaptable to meet specific organizational requirements.

Prerequisites

    MikroTik RouterOS Version 7.x or later.

    Access to the MikroTik router via Winbox, SSH, or WebFig.

    Basic understanding of networking concepts and MikroTik RouterOS.

---

## Installation and Setup
#### Backup Existing Configuration

Before applying the new firewall configuration, create a backup of your current setup and download it to your PC:

```bash
/system backup save name=YourDeviceIdentity;
/export file=YourDeviceIdentity;
```

__Download the .rsc configuration file from this repository and edit the predefined values to match your need and then copy and paste it into terminal.__
[Firewall-Rules.rsc](https://github.com/hsm1391/Advanced-MikroTik-Firewall/blob/main/Firewall-Rules.rsc)

#### Verify Configuration

Ensure the rules have been applied correctly by reviewing the firewall.

---
 
## Configuration Overview
1. Firewall Filter Rules

    Input Chain: Filters traffic destined for the router itself (e.g., management access).
    Forward Chain: Controls traffic passing through the router between networks or interfaces.
    Output Chain: Manages traffic originating from the router (e.g., router-initiated connections).

Example Rule:
bash
Copy

/ip firewall filter add chain=input protocol=tcp dst-port=22 action=accept comment="Allow SSH Access"

2. Address Lists

    Blacklist: Blocks known malicious IP addresses.

    Whitelist: Permits trusted IP addresses.

Example:
bash
Copy

/ip firewall address-list add list=blacklist address=192.168.1.100

3. GeoIP Filtering

Restrict traffic from specific countries to reduce exposure to high-risk regions:
bash
Copy

/ip firewall filter add chain=input src-address-list=!allowed_countries action=drop

4. DoS/DDoS Protection

Implement connection rate limiting to mitigate flooding attacks:
bash
Copy

/ip firewall filter add chain=forward protocol=tcp connection-limit=10,32 action=drop comment="Prevent DoS Attacks"

5. VLAN Security

Enforce isolation between VLANs to enhance internal security:
bash
Copy

/ip firewall filter add chain=forward in-interface=vlan10 out-interface=vlan20 action=drop comment="Block VLAN10 to VLAN20 Traffic"

Logging and Monitoring
Enable Logging for Specific Rules

Logging can be enabled for individual rules to facilitate auditing and troubleshooting:
bash
Copy

/ip firewall filter add chain=input action=log log-prefix="Blocked Input Traffic"

View Logs

Access the logs to monitor firewall activity:
bash
Copy

/log print

Customization

This configuration is designed to be highly customizable. Key areas for customization include:

    Updating the allowed_countries list for GeoIP filtering.

    Adding or modifying rules to align with organizational security policies.

    Adjusting rate limits and connection thresholds based on network traffic patterns.

Best Practices

    Test in a Controlled Environment: Before deploying to production, test the configuration in a lab or staging environment.

    Regular Updates: Periodically review and update the firewall rules to address emerging threats.

    Document Changes: Maintain a changelog for all modifications to the firewall configuration.

    Monitor Logs: Regularly review firewall logs to identify and respond to potential security incidents.

---
 
## Troubleshooting

> Rule Order: Ensure rules are ordered correctly, as MikroTik processes rules on a first-match basis.
> Logs: Use logs to identify and resolve issues with blocked traffic.
> Testing: Verify the configuration by simulating traffic and monitoring the results.

---
 
## Contributing

#### Contributions to this project are welcome. To contribute:

Fork the repository.
Create a new branch for your changes.
Submit a pull request with a detailed description of your modifications.

---
 
This configuration is provided as-is, without warranty of any kind. Use it at your own risk. The authors are not responsible for any damages or losses resulting from the use of this configuration. Always ensure you fully understand the implications of each rule before applying it to a production environment.

For additional resources and documentation, visit the official MikroTik Documentation: https://help.mikrotik.com/