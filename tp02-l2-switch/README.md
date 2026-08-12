## *`Topology 02: Layer 2 Switching`*

<img width="982" height="412" alt="tp02-screenshot01" src="https://github.com/user-attachments/assets/45466700-c437-4706-ba76-67b26411c096" />


#### OVERVIEW
```text
This topology introduces intermediate Layer 2 infrastructure. By integrating a managed Cisco switch, 
the network expands from a simple point-to-point link into a scalable Local Area Network (LAN). 
The focus shifts to understanding how switches learn hardware addresses and intelligently forward 
frames within a single broadcast domain, eliminating the need for strict physical adjacency.
```

#### PART 01, SWITCHED INFRASTRUCTURE (GNS3)

```text
- Deploys three isolated Alpine Linux container hosts (host-1, host-2, host-3).
- Integrates a central CiscoIOSvL2 managed switch to serve as the distribution point.
- Connects all three hosts to the switch, effectively placing them within the same physical broadcast domain.
```

#### PART 02, INTERFACE CONFIGURATION (STATIC IPS)

```text
- Configures static IPv4 addressing using the standard networking interfaces configuration file.
- All hosts are provisioned within the same 10.0.0.0/24 subnet to ensure Layer 3 compatibility 
  without routing.
- host-1 is assigned 10.0.0.1.
- host-2 is assigned 10.0.0.2.
- host-3 is assigned 10.0.0.3.
- Runtime verification confirms the active IP (10.0.0.1), subnet mask (255.255.255.0), 
  and the local hardware MAC address on the eth0 interface.
```

<img width="788" height="185" alt="tp02-ifc-confs" src="https://github.com/user-attachments/assets/b88b80f2-8718-4790-a4fa-acdda8611693" />


#### PART 03, INITIAL SWITCH STATE (EMPTY MAC TABLE)

```text
- Examines the core function of a Layer 2 switch: dynamic hardware address learning.
- Before any traffic is generated on the network, the switch has no awareness of the connected devices.
- The switch's MAC address table is queried and verified to be entirely empty.
```

<img width="1008" height="501" alt="tp02-switch-mtable0" src="https://github.com/user-attachments/assets/36ada0a6-b64b-443f-8ab3-da38c504847d" />


#### PART 04, TRAFFIC GENERATION and CONNECTIVITY (ICMP / ARP)

```text
- Initiates communication across the switch to trigger hardware address resolution and dynamic learning.
- Utilizes the Internet Control Message Protocol (ICMP) to execute continuous ping diagnostics.
```

<img width="790" height="137" alt="tp02-icmp-success" src="https://github.com/user-attachments/assets/920e6c48-5333-472d-9ec9-2d875af06432" />


```
- The packet capture explicitly reveals the sequence: an initial ARP broadcast request is flooded 
  by the switch, followed by a direct ARP reply, which then unlocks the rapid transmission of 
  unicast ICMP Echo Request and Echo Reply frames.
```

<img width="942" height="376" alt="tp02-capture" src="https://github.com/user-attachments/assets/2ec7901c-5263-416c-ab48-90ffca547c8b" />


#### PART 05, SWITCH LEARNING and HOST ARP CACHE

```text
- Validates the aftermath of the network traffic on both the switch and the endpoint.
- By inspecting the source MAC addresses of the incoming frames during the ping, the switch 
  dynamically populates its memory, mapping host MAC addresses to specific physical ingress ports 
  (e.g., 0242.7e5c.b200 mapped to Gi0/2 on VLAN 1).
```

<img width="1008" height="194" alt="tp02-switch-mtable1" src="https://github.com/user-attachments/assets/887e4508-e58d-4cce-9fee-87668c504904" />


```
- Simultaneously, the host's local ARP table accurately caches and displays the successful 
  IP-to-MAC mappings for the communicating endpoints on the subnet.
```

<img width="790" height="269" alt="tp02-arp-success" src="https://github.com/user-attachments/assets/71494e8e-3f2e-45fd-bd7c-9c9ae9f31272" />
