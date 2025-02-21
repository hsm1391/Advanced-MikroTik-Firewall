# =======================================================
#                     Advanced MikroTik Firewall
# =======================================================
# Author:            [hsm1391]
# Version:           [Version 1.0]
# =======================================================
# Usage Instructions:
# [Edit predefined values and then copy and paste it into terminal]
# =======================================================
# Known Issues:
# - [Issue 1]: [To be discovered]
# =======================================================
# Related Files:
# - [AMF-Naming-Conventions]: [Description of naming convention used in firewall]
# =======================================================
# Change Log:
# - [1-27-2025]: [Release date]
# =======================================================
# Future Work:
# [Modularization of firewall rules]
# =======================================================
# Contact Information:
# - Author Email: [hsm1391business@gmail.com]
# =======================================================
# Description:
# *For enhanced security, it is recommended to first implement the hardening script and then configure this firewall.
# Ease load on firewall by using no-mark as a mark for packets and connections.
# When a packet travels through the firewall it is checked against each rule until it matches one (except when passthrough action is used).
# If you use rules which have action mark-packet and mark-connection, then it is worth to set additional matcher as no-mark for the related parameter, it will allow for the firewall to decide sooner.
# =======================================================
# Predefined values

# *Input the name of your country's IP address list.
:global GeoLocationAddressList ""

# *Input your used TCP and UDP ports. For example, enter your Winbox port if it is not set to the default.
:global TCPUsedPorts "8291,1701"
:global UDPUsedPorts "4500,500,1701"
# *Input your lan address.
:global YourLanAddress "192.168.88.0/24"
# =======================================================
# Defining WAN and LAN

/interface list {
add name=LAN
add name=WAN
}

# =======================================================
# Firewall Filter Forward Chain Rules

/ip firewall filter {
add action=fasttrack-connection chain=forward comment=FF_FT_Est/Rel connection-state=established,related disabled=yes hw-offload=yes packet-mark=no-mark
add action=accept chain=forward comment=FF_A_Est/Rel/Unt connection-state=established,related,untracked disabled=yes packet-mark=no-mark
add action=drop chain=forward comment=FF_D_Invalid connection-state=invalid disabled=yes packet-mark=no-mark
add action=drop chain=forward comment=FF_D_BadForwardIPs disabled=yes packet-mark=no-mark src-address-list=AL_BL_NoForwardIPV4
add action=drop chain=forward comment=FF_D_BadForwardIPs disabled=yes dst-address-list=AL_BL_NoForwardIPV4 packet-mark=no-mark
add action=drop chain=forward comment=FF_D_!DSTN connection-nat-state=!dstnat connection-state=new disabled=yes in-interface-list=WAN packet-mark=no-mark
}
# =======================================================
# Firewall Filter Input Chain Rules

/ip firewall filter {
add action=fasttrack-connection chain=input comment=FI_FT_Est/Rel connection-state=established,related disabled=yes hw-offload=yes packet-mark=no-mark
add action=accept chain=input comment=FI_A_Est/Rel/Unt connection-state=established,related,untracked disabled=yes packet-mark=no-mark
add action=drop chain=input comment=FI_D_Invalid connection-state=invalid disabled=yes packet-mark=no-mark
add action=accept chain=input comment=FI_A_ICMP disabled=yes packet-mark=no-mark protocol=icmp
add action=accept chain=input comment=FI_A_Proto50/L2TP disabled=yes packet-mark=no-mark protocol=ipsec-esp src-address-list=$GeoLocationAddressList
add action=jump chain=input comment=FI_J_InputTCP disabled=yes jump-target=Input_TCP packet-mark=no-mark protocol=tcp
add action=jump chain=input comment=FI_J_InputUDP disabled=yes jump-target=Input_UDP packet-mark=no-mark protocol=udp
add action=drop chain=input comment=FI_D_!LAN disabled=yes in-interface-list=!LAN packet-mark=no-mark
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:PS disabled=yes log=yes log-prefix=FC_AS_TCP:PS packet-mark=no-mark protocol=tcp psd=21,5m,3,1
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:!FIN/!SYN/!RST/!ACK:PS disabled=yes log=yes log-prefix=FC_AS_TCP:!FIN/!SYN/!RST/!ACK:PS packet-mark=no-mark protocol=tcp tcp-flags=!fin,!syn,!rst,!ack
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:FIN/!SYN/!RST/!PSH/!ACK/!URG:PS disabled=yes log=yes log-prefix=FC_AS_TCP:FIN/!SYN/!RST/!PSH/!ACK/!URG:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,!syn,!rst,!psh,!ack,!urg
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:SYN/FIN:PS disabled=yes log=yes log-prefix=FC_AS_TCP:SYN/FIN:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,syn
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:FIN/RST:PS disabled=yes log=yes log-prefix=FC_AS_TCP:FIN/RST:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,rst
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:FIN/!ACK:PS disabled=yes log=yes log-prefix=FC_AS_TCP:FIN/!ACK:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,!ack
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:FIN/URG:PS disabled=yes log=yes log-prefix=FC_AS_TCP:FIN/URG:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,urg
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:SYN/RST:PS disabled=yes log=yes log-prefix=FC_AS_TCP:SYN/RST:PS packet-mark=no-mark protocol=tcp tcp-flags=syn,rst
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:RST/URG:PS disabled=yes log=yes log-prefix=FC_AS_TCP:RST/URG:PS packet-mark=no-mark protocol=tcp tcp-flags=rst,urg
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:FIN/SYN/RST/PSH/ACK/URG:PS disabled=yes log=yes log-prefix=FC_AS_TCP:FIN/SYN/RST/PSH/ACK/URG:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,syn,rst,psh,ack,urg
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:FIN/!SYN/!RST/PSH/!ACK/URG:PS disabled=yes log=yes log-prefix=FC_AS_TCP:FIN/!SYN/!RST/PSH/!ACK/URG:PS packet-mark=no-mark protocol=tcp tcp-flags=fin,psh,urg,!syn,!rst,!ack
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:!FIN/!SYN/!RST/!PSH/!ACK/!URG:PS disabled=yes log=yes log-prefix=FC_AS_TCP:!FIN/!SYN/!RST/!PSH/!ACK/!URG:PS packet-mark=no-mark protocol=tcp tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:SYNFragment disabled=yes fragment=yes log=yes log-prefix=FC_AS_TCP:SYNFragment packet-mark=no-mark protocol=tcp tcp-flags=syn
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_TCP comment=FC_AS_TCP:Port0:BT disabled=yes log=yes log-prefix=FC_AS_TCP:Port0:BT packet-mark=no-mark port=0 protocol=tcp
add action=accept chain=Input_TCP comment=FC_A_Accept:UsedServices connection-state=new disabled=yes dst-port=$TCPUsedPorts packet-mark=no-mark protocol=tcp src-address-list=$GeoLocationAddressList
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_UDP comment=FC_AS_UDP:PS disabled=yes log=yes log-prefix=FC_AS_UDP:PS packet-mark=no-mark protocol=udp psd=21,5m,3,1 src-address-list=!AL_T_DNS
add action=add-src-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1w chain=Input_UDP comment=FC_AS_UDP:BadUDP disabled=yes log=yes log-prefix=FC_D_UDP:BadUDP packet-mark=no-mark port=0 protocol=udp
add action=accept chain=Input_UDP comment=FC_A_UsedServices disabled=yes dst-port=$UDPUsedPorts packet-mark=no-mark protocol=udp src-address-list=$GeoLocationAddressList
add action=accept chain=Input_UDP comment=FC_A_NTP disabled=yes dst-port=123 packet-mark=no-mark protocol=udp src-address-list=AL_T_NTP src-port=123
}

# =======================================================
# Firewall Filter Output Chain Rules
/ip firewall filter {
add action=fasttrack-connection chain=output comment=FO_FT_Est/Rel connection-state=established,related disabled=yes hw-offload=yes packet-mark=no-mark
add action=accept chain=output comment=FO_A_Est/Rel/Unt connection-state=established,related,untracked disabled=yes packet-mark=no-mark
add action=add-dst-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=10m chain=output comment=FO_AD_WinboxF2B#3 content="invalid user name or password" disabled=yes dst-address-list=AL_B_F2B#2 log=yes log-prefix=FO_AD_WinboxF2B#3 packet-mark=no-mark protocol=tcp src-port=58291
add action=add-dst-to-address-list address-list=AL_B_F2B#2 address-list-timeout=2m chain=output comment=FO_AD_WinboxF2B#2 content="invalid user name or password" disabled=yes dst-address-list=AL_B_F2B#1 packet-mark=no-mark protocol=tcp src-port=58291
add action=add-dst-to-address-list address-list=AL_B_F2B#1 address-list-timeout=1m chain=output comment=FO_AD_WinboxF2B#1 content="invalid user name or password" disabled=yes packet-mark=no-mark protocol=tcp src-port=58291
add action=add-dst-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1d chain=output comment=FO_AD_L2TPF2B#3 content="authentication failed" disabled=yes dst-address-list=AL_B_F2B#2 log=yes log-prefix=FO_AD_L2TPF2B#3 packet-mark=no-mark protocol=udp src-port=1701
add action=add-dst-to-address-list address-list=AL_B_F2B#2 address-list-timeout=15m chain=output comment=FO_AD_L2TPF2B#2 content="authentication failed" disabled=yes dst-address-list=AL_B_F2B#1 packet-mark=no-mark protocol=udp src-port=1701
add action=add-dst-to-address-list address-list=AL_B_F2B#1 address-list-timeout=15m chain=output comment=FO_AD_L2TPF2B#1 content="authentication failed" disabled=yes packet-mark=no-mark protocol=udp src-port=1701
add action=add-dst-to-address-list address-list=AL_BL_Blacklisted address-list-timeout=1d5m chain=output comment=FO_AD_PPTPF2B#3 content="authentication failed" disabled=yes dst-address-list=AL_B_F2B#2 log=yes log-prefix=FO_AD_PPTPF2B#3 packet-mark=no-mark protocol=gre
add action=add-dst-to-address-list address-list=AL_B_F2B#2 address-list-timeout=15m chain=output comment=FO_AD_PPTPF2B#2 content="authentication failed" disabled=yes dst-address-list=AL_B_F2B#1 packet-mark=no-mark protocol=gre
add action=add-dst-to-address-list address-list=AL_B_F2B#1 address-list-timeout=15m chain=output comment=FO_AD_PPTPF2B#1 content="authentication failed" disabled=yes packet-mark=no-mark protocol=gre
}
 
# =======================================================
# Firewall Raw Prerouting Rules

/ip firewall raw {
add action=accept chain=prerouting comment=RP_A_UDP:DHCPDiscover disabled=yes dst-address=255.255.255.255 dst-port=67 in-interface-list=LAN protocol=udp src-address=0.0.0.0 src-port=68
add action=accept chain=prerouting comment=RP_A_Whitelisted disabled=yes src-address-list=AL_W_Whitelisted
add action=accept chain=prerouting comment=RP_A_Whitelisted disabled=yes dst-address-list=AL_W_Whitelisted
add action=drop chain=prerouting comment=RP_D_Blacklisted disabled=yes src-address-list=AL_BL_Blacklisted
add action=drop chain=prerouting comment=RP_D_Blacklisted disabled=yes dst-address-list=AL_BL_Blacklisted
add action=drop chain=prerouting comment=RP_D_BadIPV4 disabled=yes src-address-list=AL_BL_BadIPV4
add action=drop chain=prerouting comment=RP_D_BadIPV4 disabled=yes dst-address-list=AL_BL_BadIPV4
add action=drop chain=prerouting comment=RP_D_BadSrcIPV4 disabled=yes src-address-list=AL_BL_BadSrcIPV4
add action=drop chain=prerouting comment=RP_D_BadDstIPV4 disabled=yes dst-address-list=AL_BL_BadDstIPV4
add action=drop chain=prerouting comment=RP_D_NotGlobalIPV4 disabled=yes in-interface-list=WAN src-address-list=AL_BL_NotGlobalIPV4
add action=drop chain=prerouting comment=RP_D_ForwardToLANFromWAN disabled=yes in-interface-list=WAN src-address-list=AL_T_LAN
add action=drop chain=prerouting comment=RP_D_SrcSpoof disabled=yes in-interface-list=LAN src-address-list=!AL_T_LAN
add action=jump chain=prerouting comment=RP_J_preroutingICMP4 disabled=yes jump-target=prerouting_icmp4 protocol=icmp
add action=accept chain=prerouting comment=RP_A_LAN disabled=yes in-interface-list=LAN
add action=accept chain=prerouting comment=RP_A_WAN disabled=yes in-interface-list=WAN
add action=drop chain=prerouting comment=RP_D_NotInterfaceListed disabled=yes
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:EchoReply disabled=yes icmp-options=0:0 limit=5,10:packet protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:NetUnreachable disabled=yes icmp-options=3:0 protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:HostUnreachable disabled=yes icmp-options=3:1 protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:ProtocolUnreachable disabled=yes icmp-options=3:2 protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:PortUnreachable disabled=yes icmp-options=3:3 protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:FragmentationNeeded disabled=yes icmp-options=3:4 protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:Echo disabled=yes icmp-options=8:0 limit=5,10:packet protocol=icmp
add action=accept chain=prerouting_icmp4 comment=RC_A_ICMP4:TimeExceeded disabled=yes icmp-options=11:0-255 protocol=icmp
add action=drop chain=prerouting_icmp4 comment=RC_D_ICMP4:ImplicitDeny disabled=yes protocol=icmp
add action=drop chain=prerouting comment=RP_D_IPOptionLooseSourceRouting disabled=yes ipv4-options=loose-source-routing
add action=drop chain=prerouting comment=RP_D_IPOptionStrictSourceRouting disabled=yes ipv4-options=strict-source-routing
add action=drop chain=prerouting comment=RP_D_IPOptionRecordRoute disabled=yes ipv4-options=record-route
add action=drop chain=prerouting comment=RP_D_IPOptionRouteAlert disabled=yes ipv4-options=router-alert
add action=drop chain=prerouting comment=RP_D_IPOptionTimestamp disabled=yes ipv4-options=timestamp
add action=drop chain=prerouting comment=RP_D_IPOptionExceptIPStreamIGMP disabled=yes ipv4-options=any protocol=!igmp
}

# =======================================================
# Firewall Raw Prerouting Rules
/ip firewall raw {
add action=accept chain=output comment=RO_A_Whitelisted disabled=yes src-address-list=AL_W_Whitelisted
add action=accept chain=output comment=RO_A_Whitelisted disabled=yes dst-address-list=AL_W_Whitelisted
add action=drop chain=output comment=RO_D_Blacklisted disabled=yes src-address-list=AL_BL_Blacklisted
add action=drop chain=output comment=RO_D_Blacklisted disabled=yes dst-address-list=AL_BL_Blacklisted
}

# =======================================================
# Firewall Address Lists
/ip firewall address-list {
add address=0.0.0.0/8 comment=RFC6890 list=AL_BL_NoForwardIPV4
add address=169.254.0.0/16 comment=RFC6890 list=AL_BL_NoForwardIPV4
add address=224.0.0.0/4 comment=multicast list=AL_BL_NoForwardIPV4
add address=255.255.255.255 comment=RFC6890 list=AL_BL_NoForwardIPV4
add address=127.0.0.0/8 comment=RFC6890 list=AL_BL_BadIPV4
add address=192.0.0.0/24 comment=RFC6890 list=AL_BL_BadIPV4
add address=192.0.2.0/24 comment="RFC6890 documentation" list=AL_BL_BadIPV4
add address=198.51.100.0/24 comment="RFC6890 documentation" list=AL_BL_BadIPV4
add address=203.0.113.0/24 comment="RFC6890 documentation" list=AL_BL_BadIPV4
add address=240.0.0.0/4 comment="RFC6890 reserved" list=AL_BL_BadIPV4
add address=0.0.0.0/8 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=10.0.0.0/8 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=100.64.0.0/10 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=169.254.0.0/16 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=172.16.0.0/12 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=192.0.0.0/29 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=192.168.0.0/16 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=198.18.0.0/15 comment="RFC6890 benchmark" list=AL_BL_NotGlobalIPV4
add address=255.255.255.255 comment=RFC6890 list=AL_BL_NotGlobalIPV4
add address=224.0.0.0/4 comment=multicast list=AL_BL_BadSrcIPV4
add address=255.255.255.255 comment=RFC6890 list=AL_BL_BadSrcIPV4
add address=0.0.0.0/8 comment=RFC6890 list=AL_BL_BadDstIPV4
add address=224.0.0.0/4 comment=RFC6890 list=AL_BL_BadDstIPV4
add address=162.159.200.1 list=AL_T_NTP
add address=8.8.8.8 list=AL_T_DNS
add address=8.8.4.4 list=AL_T_DNS
add address=$YourLanAddress list=AL_T_LAN
}
# =======================================================
