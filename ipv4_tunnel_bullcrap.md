Because of the pure bullshit that is some ISPs (multiple now) that have horrible ipv4 setups but for some reason workable ipv6. The goal/idea is use linux routing (iptables) with ssh tunnels. This document is my WIP documenting this each time I have to set this up. Eventually I would love to have these be automatically done via scripts.


Links of use in no particular order:
----------


* http://how-to.wikia.com/wiki/How_to_set_up_a_NAT_router_on_a_Linux-based_computer
* https://help.ubuntu.com/community/SSH_VPN


Commands of use:
--------

* `sudo iptables-save`
* `ip addr show`
* `route -vn` (verbose, no dns)


Route of ipv4 packet from net-local machine (not routing machine):
-------

1. $DEVICE points to $IPV4_GATEWAY (the laptop normally)
2. $GATEWAY iptables and sysctl forwards & masquerades packet (NAT) to
3. $TUN_LOCAL routes to peer connection $TUN_SERVER
4. $TUN_SERVER iptables forwards & NATs to global ipv4 space
5. NORMAL INTERNET ROUTING HAPPENS FROM HERE (based from ipv4 space of SERVER)
6. $SERVER iptables RELATED,ESTABLISHED forwards back to $TUN_SERVER
7. $TUN_SERVER de-masqs back to $TUN_LOCAL
8. $TUN_LOCAL de-masqs to $GATEWAY NIC (eth0? wlan0?)
9. $GATEWAY iptables forwards back to $DEVICE


Persistent config(s):
=========


Server:
-------

* `sudo ip link set tun0 up`
* `sudo ip addr add ${SERVER_ADDR}/32 peer ${LAPTOP_ADDR} dev tun0`
* `sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE`
* `sudo iptables -t filter -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT`
  * (Is the eth0-->tun0 filter required?)
* `sudo iptables -t filter -A FORWARD -i tun0 -o eth0 -j ACCEPT`
* `sudo sysctl net.ipv4.ip_forward=1`

Server-SSHDconfig:
------------------

    PermitTunnel point-to-point

Laptop:
-------

* `sudo ip link set tun0 up`
* `sudo ip addr add ${LAPTOP_ADDR}/32 peer ${SERVER_ADDR} dev tun0`
* `sudo sysctl net.ipv4.ip_forward=1`
* `sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o tun0 -j MASQUERADE`
* `sudo iptables -t filter -A FORWARD -s 10.0.0.0/24 -i eth0 -j ACCEPT`
* `sudo ip route replace default via 10.10.10.2`

Laptop-sshconfig:
----

    Host ipv6.admalledd.com
        Tunnel point-to-point
        TunnelDevice 0:0
        DynamicForward 1985

Working config statuses
==============


Server:
-------

    6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 500
        link/none 
        inet 10.10.10.2/32 scope global tun0
           valid_lft forever preferred_lft forever
        inet 10.10.10.2 peer 10.10.10.1/32 scope global tun0
           valid_lft forever preferred_lft forever

----

    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         $SERVER_ADDR    0.0.0.0         UG    0      0        0 eth0
    10.10.10.1      0.0.0.0         255.255.255.255 UH    0      0        0 tun0
    $SERVER_ADDR    0.0.0.0         255.255.255.0   U     0      0        0 eth0


Laptop:
-------

    4: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 500
    link/none 
    inet 10.10.10.1/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet 10.10.10.1 peer 10.10.10.2/32 scope global tun0
       valid_lft forever preferred_lft forever

----

    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         10.0.0.1        0.0.0.0         UG    0      0        0 eth0
    10.0.0.0        0.0.0.0         255.255.255.0   U     1      0        0 eth0
    10.10.10.0      0.0.0.0         255.255.255.0   U     0      0        0 tun0
    10.10.10.2      0.0.0.0         255.255.255.255 UH    0      0        0 tun0
