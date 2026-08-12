## *`Topology 04: Inter-VLAN Routing (ROAS)`*

<img width="1325" height="782" alt="tp04-screen0" src="https://github.com/user-attachments/assets/4c73f0a1-9cd5-4f81-a075-ba5efaeba65a" />

#### OVERVIEW
```text
This topology bridges the gap between isolated Layer 2 broadcast domains by introducing a Layer 3 
routing engine. It implements the classic "Router-on-a-Stick" (ROAS) architecture, demonstrating 
how a single physical router interface can be virtually partitioned to act as the default gateway 
for multiple distinct subnets, enabling inter-VLAN communication.
```

#### PART 01, INFRASTRUCTURE and TOPOLOGY OVERVIEW

```text
- Upgrades the isolated Layer 2 architecture by introducing a CiscoIOSv Router to the core.
- Utilizes a single physical uplink cable between the distribution switch and the router.
- All four hosts are assigned static IP addresses and, critically, default gateways 
  pointing to the router's virtual interfaces, giving them a path to unknown networks.
```

#### PART 02, SWITCH TRUNKING and HOST PROVISIONING

```text
- The switch configuration retains the VLAN 10 (BLUE_NET) and VLAN 20 (RED_NET) access boundaries 
  for the connected endpoints.
- The uplink port connecting to the router (Gi0/0) is configured as a strict 802.1Q trunk. 
- This configuration ensures the switch preserves the VLAN tags when forwarding traffic up to 
  the routing plane, allowing the router to distinguish which broadcast domain the traffic originated from.
```

#### PART 03, ROUTER VIRTUALIZATION (SUBINTERFACES)

```text
- To route multiple networks over a single physical wire, the router's main hardware interface 
  (Gi0/0) is brought online ("no shutdown") but purposefully left unassigned without an IP address.
- Logical subinterfaces (Gi0/0.10 and Gi0/0.20) are spawned directly from the physical port.
- Each subinterface is explicitly bound to a specific broadcast domain using the 
  "encapsulation dot1Q <vlan-id>" command.
- The subinterfaces are assigned their respective gateway IP addresses (10.0.10.254/24 and 10.0.20.254/24), 
  anchoring the Layer 3 subnets to the router.
```

<img width="1054" height="388" alt="tp04-router-subifc-cnf" src="https://github.com/user-attachments/assets/7082ed0a-6285-4090-a2ac-8d588f11e2d0" />


#### PART 04, DATA PLANE VALIDATION and TAG SWAPPING

```text
- Validates successful inter-VLAN routing: host-1 (10.0.10.1 in BLUE_NET) executes a successful 
  ICMP ping to host-3 (10.0.20.1 in RED_NET).
```

<img width="839" height="339" alt="tp04-icmp-success" src="https://github.com/user-attachments/assets/5a1faaf6-3ae5-4e63-86ac-38c1a8778533" />

```
- The packet captures directly intercept the trunk link, revealing the router's internal 
  tag-swapping mechanics.
- INGRESS: The router receives the ICMP Echo Request arriving from the switch, explicitly 
  tagged with 802.1Q ID: 10.
```

<img width="971" height="498" alt="tp04-icmp-request-capture" src="https://github.com/user-attachments/assets/0cd260c5-259f-4afe-8aad-d193a412f157" />


```
- EGRESS: The router accepts the frame on Gi0/0.10, strips the VLAN 10 tag, performs a routing 
  table lookup, resolves the destination to Gi0/0.20, and transmits the ICMP Request back down 
  the exact same physical wire, but re-tagged with ID: 20.
```

<img width="971" height="498" alt="tp04-icmp-response-capture" src="https://github.com/user-attachments/assets/c77ad959-141f-4b69-94f6-f70904931265" />
