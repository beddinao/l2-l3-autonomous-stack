
# *`Topology 01: Direct Link`*

<img width="1271" height="629" alt="tp01-screen2" src="https://github.com/user-attachments/assets/22453bdd-abed-4a6d-90e7-651e29cce48d" />


### OVERVIEW
```text
A foundational point-to-point network architecture. This topology strips away intermediary infrastructure 
(switches and routers) to observe raw Layer 2 and Layer 3 communication mechanics on a single wire. 
It establishes the baseline for static IP configuration and protocol-level host discovery.
```

### PART 01, BASELINE INFRASTRUCTURE (GNS3)

```text
- Deploys two isolated Alpine Linux container hosts (host-1 and host-2).
- Connects both nodes directly via their primary eth0 interfaces.
- Establishes absolute physical (Layer 1) adjacency with no switching hardware in the data path.
```

### PART 02, INTERFACE CONFIGURATION (STATIC IPS)

```text
- Configures static IPv4 addressing using the standard networking interfaces configuration file.
- host-1 is assigned 192.168.0.1/24.
- host-2 is assigned 192.168.0.2/24.
- Runtime verification of the eth0 interface confirms the active IP (192.168.0.2), 
  subnet mask (255.255.255.0), and the local hardware MAC address.
```

<img width="790" height="179" alt="tp01-ifc-configs" src="https://github.com/user-attachments/assets/43dc6a09-6913-453b-9666-a71124eaf1c0" />


### PART 03, HOST DISCOVERY (ARP)

```text
- Before standard IP packets can be transferred, hosts must resolve Layer 2 hardware addresses.
- Demonstrates the Address Resolution Protocol (ARP) in action: the host sends a broadcast frame 
  (ff:ff:ff:ff:ff:ff) asking "Who has 192.168.0.1?".
- The target replies directly with its specific MAC address (02:42:56:0b:58:00).
- The local ARP table accurately caches and displays this successful IP-to-MAC mapping.
```

<img width="790" height="179" alt="tp01-arp-success" src="https://github.com/user-attachments/assets/0989b43d-a278-4969-945b-058f722a11e1" />


### PART 04, CONNECTIVITY VALIDATION (ICMP)

```text
- Validates bidirectional Layer 3 routing and reachability across the direct wire.
- Utilizes the Internet Control Message Protocol (ICMP) to execute continuous ping diagnostics.
```

<img width="790" height="174" alt="tp01-icmp-success" src="https://github.com/user-attachments/assets/9ecb9b11-b6e5-4aac-92d0-37a07e1fd000" />

```
- The packet capture explicitly reveals the protocol sequence: ARP resolution must complete 
  successfully first, which unlocks the transmission of consecutive ICMP Echo Request 
  and Echo Reply frames.
```

<img width="939" height="291" alt="tp01-link-capture" src="https://github.com/user-attachments/assets/1850c67a-86a3-4527-be0f-34ad9f3d31b6" />

