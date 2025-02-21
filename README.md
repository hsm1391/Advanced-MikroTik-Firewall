# Advanced MikroTik Firewall

This document contains a professional-grade firewall configuration for MikroTik routers, designed to enhance network security, optimize traffic management, and protect against modern cyber threats. The configuration is tailored for enterprise environments, ensuring robust protection while maintaining high performance and scalability.

__It is advised to use the hardening script beforehand to ensure maximum security. It is available from the link below.__
[MikroTik-Hardening](https://github.com/hsm1391/MikroTik-Hardening)

---

## Table of Contents
1. [Key Features](#key-features)
2. [Prerequisites](#prerequisites)
3. [Contributing](#contributing)
4. [Installation and Setup](#installation-and-setup)
5. [Configuration Overview](#configuration-overview)
   - [Firewall Rules](#firewall-rules)
   - [Address Lists](#address-lists)
   - [GeoIP Filtering](#geoip-filtering)
6. [Customization](#customization)
7. [Best Practices](#best-Practices)
8. [Troubleshooting](#troubleshooting)
9. [Contributing](#contributing)

---

## Key Features

> __Custom Chains:__ Use Custom Chains to improve performance.

> __Portscan and Bruteforce Protection:__ Protects against portscan and bruteforce attacks.

> __Advanced Logging and Monitoring:__ Detailed logging for auditing, troubleshooting, and compliance.
[Using Splunk to analyse MikroTik logs 4.0](https://forum.mikrotik.com/viewtopic.php?t=179960)

> __GeoIP Filtering:__ Restricts traffic based on geographic regions to minimize exposure.

> __Filter Bad IPV4 Traffics:__ Drops RFC6890.

> __Customizable Ruleset:__ Easily adaptable to meet specific organizational requirements.

## Prerequisites

> Access to the MikroTik router via Winbox, SSH, or WebFig.

> Basic understanding of networking concepts and MikroTik RouterOS.

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
1. Firewall Rules

    For naming conventions, you should review the file below to understand the meaning of each comment.
    [AMF-Naming-Conventions](https://github.com/hsm1391/Advanced-MikroTik-Firewall/blob/main/AMF-Naming-Conventions)

```console
FF_FT_Est/Rel = Enables Fast Track for established and related connections.
FF_A_Est/Rel/Unt = Accept established/related/untracked connections.
FF_D_Invalid = Drop invalid connections.
FF_D_BadForwardIPs = Drop addresses that cannot be forwarded
FF_D_!DSTN = Drop routed packets coming from your WAN towards your LAN.

FI_FT_Est/Rel = Enables Fast Track for established and related connections.
FI_A_Est/Rel/Unt = Accept established/related/untracked connections.
FI_D_Invalid = Drop invalid connections.
FI_A_ICMP = Accept ICMP.
FI_A_Proto50/L2TP = Accept L2TP.
FI_J_InputTCP = Jumps to Custom input TCP chain.
FI_J_InputUDP = Jumps to Custom input UDP chain.
FI_D_!LAN =  Drops everything not originated from LAN.

FC_AS_TCP:PS = Catch TCP portscan.
FC_AS_TCP:!FIN/!SYN/!RST/!ACK:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:FIN/!SYN/!RST/!PSH/!ACK/!URG:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:SYN/FIN:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:FIN/RST:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:FIN/!ACK:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:FIN/URG:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:SYN/RST:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:RST/URG:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:FIN/SYN/RST/PSH/ACK/URG:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:FIN/!SYN/!RST/PSH/!ACK/URG:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:!FIN/!SYN/!RST/!PSH/!ACK/!URG:PS = Catch TCP invalid flag portscan.
FC_AS_TCP:SYNFragment = Catch fragmented SYN scan.
FC_AS_TCP:Port0:BT = Catch Port 0.

FC_AS_UDP:PS = Catch UDP portscan.
FC_AS_UDP:BadUDP = Catch UDP bad traffic.
FC_A_UsedServices = Accept used UDP ports.
FC_A_NTP = Accept NTP traffic.

FO_FT_Est/Rel = Enables Fast Track for established and related connections.
FO_A_Est/Rel/Unt = Accept established/related/untracked connections.
FO_AD_WinboxF2B#3 = Catch Winbox Bruteforce.
FO_AD_WinboxF2B#2 = Catch Winbox Bruteforce.
FO_AD_WinboxF2B#1 = Catch Winbox Bruteforce.
FO_AD_L2TPF2B#3 = Catch L2TP Bruteforce.
FO_AD_L2TPF2B#2 = Catch L2TP Bruteforce.
FO_AD_L2TPF2B#1 = Catch L2TP Bruteforce.
FO_AD_PPTPF2B#3 = Catch PPTP Bruteforce.
FO_AD_PPTPF2B#2 = Catch PPTP Bruteforce.
FO_AD_PPTPF2B#1 = Catch PPTP Bruteforce.

RP_A_UDP:DHCPDiscover = Accept DHCP Discovery.
RP_A_Whitelisted = Accept whitelisted addresses.
RP_D_Blacklisted = Drop Blacklisted traffic (e.g portscanners)
RP_D_BadIPV4 = Drop addresses that cannot be used as src/dst/forwarded, etc.
RP_D_BadSrcIPV4 = Drop addresses that cannot be as source address.
RP_D_BadDstIPV4 = Drop addresses that cannot be as destination address.
RP_D_NotGlobalIPV4 = Drop addresses that cannot be routed globally.
RP_D_ForwardToLANFromWAN = Drop packets coming from WAN with LAN addresses.
RP_D_SrcSpoof = Drop unknown addresses coming from LAN.
RP_J_preroutingICMP4 = Jump to custom ICMP rules.
RP_A_LAN = Accept interface listed traffic from LAN intended for troubleshooting only.
RP_A_WAN = Accept Interface listed traffic from WAN intended for troubleshooting only.
RP_D_NotInterfaceListed = Drop everything not interface listed.

RC_A_ICMP4:EchoReply = Accept essential icmp traffic.
RC_A_ICMP4:NetUnreachable = Accept essential icmp traffic.
RC_A_ICMP4:HostUnreachable = Accept essential icmp traffic.
RC_A_ICMP4:ProtocolUnreachable = Accept essential icmp traffic.
RC_A_ICMP4:PortUnreachable = Accept essential icmp traffic.
RC_A_ICMP4:FragmentationNeeded = Accept essential icmp traffic.
RC_A_ICMP4:Echo = Accept essential icmp traffic.
RC_A_ICMP4:TimeExceeded = Accept essential icmp traffic.
RC_D_ICMP4:ImplicitDeny = Drop non essential icmp traffic.

RP_D_IPOptionLooseSourceRouting = Drop unused ip options.
RP_D_IPOptionStrictSourceRouting = Drop unused ip options.
RP_D_IPOptionRecordRoute = Drop unused ip options.
RP_D_IPOptionRouteAlert = Drop unused ip options.
RP_D_IPOptionTimestamp = Drop unused ip options.
RP_D_IPOptionExceptIPStreamIGMP = Drop unused ip options.

RO_A_Whitelisted = Accept whitelisted addresses.
RO_D_Blacklisted = Drop blacklisted addresses.
```

---
 
## 2. Address Lists
__RFC 6890 will be used as a reference.__

```console
AL_BL_NoForwardIPV4 = contains all IPv4 addresses that cannot be forwarded.

AL_BL_BadIPV4 = contains all IPv4 addresses that cannot be used as src/dst/forwarded, etc. (will be dropped immediately if such address is seen).

AL_BL_NotGlobalIPV4 = contains all IPv4 addresses that cannot be routed globally.

AL_BL_BadSrcIPV4 = addresses that cannot be as destination or source address.

AL_BL_BadDstIPV4 = addresses that cannot be as destination or source address.

AL_T_NTP = NTP server addresses that your router uses.

AL_T_DNS = DNS server addresses that your router uses.

AL_T_LAN = Your LAN addresses.
```

---

## 3. GeoIP Filtering

Restrict traffic from specific countries to reduce exposure. Ideally, you should add the country you currently reside in and limit access to services like Winbox to that country only.

> __There are many sites available online that provide such lists. If you need one, you can use the site below.__
https://www.ip2location.com/free/visitor-blocker

---

## Customization

This configuration is designed to be highly customizable. Key areas for customization include:

> Updating the __GeoLocationAddressList__ list for GeoIP filtering.

> Adding or modifying rules to align with organizational security policies.

> Adjusting rate limits and connection thresholds based on network traffic patterns.

---
 
## Best Practices

> Test in a Controlled Environment: Before deploying to production, test the configuration in a lab or staging environment.

> Regular Updates: Periodically review and update the firewall rules to address emerging threats.

> Monitor Logs: Regularly review firewall logs to identify and respond to potential security incidents.

---
 
## Troubleshooting

> Rule Order: Ensure rules are ordered correctly, as MikroTik processes rules on a first-match basis.

> Logs: Use logs to identify and resolve issues with blocked traffic.

> Testing: Verify the configuration by simulating traffic and monitoring the results.

---
 
## Contributing

#### Contributions to this project are welcome. To contribute:

> Fork the repository.

> Create a new branch for your changes.

> Submit a pull request with a detailed description of your modifications.

---
 
This configuration is provided as-is, without warranty of any kind. Use it at your own risk. The authors are not responsible for any damages or losses resulting from the use of this configuration. Always ensure you fully understand the implications of each rule before applying it to a production environment.

For additional resources and documentation, visit the official MikroTik Documentation: https://help.mikrotik.com/