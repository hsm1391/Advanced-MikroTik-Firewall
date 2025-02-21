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
 
# Configuration Overview
1. Firewall Filter Rules

    Input Chain: Filters traffic destined for the router itself (e.g., management access).
    Forward Chain: Controls traffic passing through the router between networks or interfaces.
    Output Chain: Manages traffic originating from the router (e.g., router-initiated connections).


---
 
## 2. Address Lists
    __RFC 6890 will be used as a reference.__

    AL_BL_NoForwardIPV4: contains all IPv4 addresses that cannot be forwarded.

    AL_BL_BadIPV4: contains all IPv4 addresses that cannot be used as src/dst/forwarded, etc. (will be dropped immediately if such address is seen).

    AL_BL_NotGlobalIPV4: contains all IPv4 addresses that cannot be routed globally.

    AL_BL_BadSrcIPV4:addresses that cannot be as destination or source address.

    AL_BL_BadDstIPV4: addresses that cannot be as destination or source address.

    AL_T_NTP: NTP server addresses that your router uses.

    AL_T_DNS: DNS server addresses that your router uses.

    AL_T_LAN: Your LAN addresses.

---

## 3. GeoIP Filtering

Restrict traffic from specific countries to reduce exposure. Ideally, you should add the country you currently reside in and limit access to services like Winbox to that country only.

__There are many sites availble online which provide that list, if you need one you can use the site below:__
https://www.ip2location.com/free/visitor-blocker

---

## 4. DoS/DDoS Protection

Implement connection rate limiting to mitigate flooding attacks:
bash
Copy

/ip firewall filter add chain=forward protocol=tcp connection-limit=10,32 action=drop comment="Prevent DoS Attacks"

## 5. VLAN Security

---
 
## Customization

This configuration is designed to be highly customizable. Key areas for customization include:

Updating the GeoLocationAddressList list for GeoIP filtering.

Adding or modifying rules to align with organizational security policies.

Adjusting rate limits and connection thresholds based on network traffic patterns.

---
 
## Best Practices

Test in a Controlled Environment: Before deploying to production, test the configuration in a lab or staging environment.

Regular Updates: Periodically review and update the firewall rules to address emerging threats.

Monitor Logs: Regularly review firewall logs to identify and respond to potential security incidents.

---
 
## Troubleshooting

Rule Order: Ensure rules are ordered correctly, as MikroTik processes rules on a first-match basis.

Logs: Use logs to identify and resolve issues with blocked traffic.

Testing: Verify the configuration by simulating traffic and monitoring the results.

---
 
## Contributing

#### Contributions to this project are welcome. To contribute:

Fork the repository.
Create a new branch for your changes.
Submit a pull request with a detailed description of your modifications.

---
 
This configuration is provided as-is, without warranty of any kind. Use it at your own risk. The authors are not responsible for any damages or losses resulting from the use of this configuration. Always ensure you fully understand the implications of each rule before applying it to a production environment.

For additional resources and documentation, visit the official MikroTik Documentation: https://help.mikrotik.com/