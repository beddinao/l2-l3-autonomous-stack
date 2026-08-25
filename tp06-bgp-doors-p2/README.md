# *`Topology 06: VXLAN (Multicast, Unicast)`*

## Objective

The goal of this topology is to implement a Virtual eXtensible Local Area Network (VXLAN) to bridge two remote Layer 2 domains across a Layer 3 routing underlay. It practically demonstrates how to stretch a local subnet (`10.0.1.0/24`) over a point-to-point transit network (`10.0.0.0/30`).

in two modes: **Unicast** and **Multicast**

## Topology Architecture

<img src="./tp06-bgp-doors-p2/screenshots/tp06-screen0.png" />

**Layer 3 Underlay:** A physical transit link between the routers.
* `router-1`: `10.0.0.1/30` (`eth0`)
* `router-2`: `10.0.0.2/30` (`eth0`)


**Layer 2 Overlay:** The stretched virtual network for the endpoints.
* `host-1`: `10.0.1.1/24` (`eth0`)
* `host-2`: `10.0.1.2/24` (`eth0`)


**VXLAN Tunnel Attributes:**
* **VNI:** `10`
* **UDP Destination Port:** `4789`
* **Multicast Group:** `239.1.1.1`



## Configuration Details

The setup utilizes local Bash scripts executed dynamically inside the Docker containers to apply the IP and bridge configurations.

### 1. Host Configuration

Both hosts are configured to exist on the same `/24` subnet. Because of the VXLAN overlay, they remain entirely unaware that a Layer 3 network separates them.

* **`host-1`:** `ip addr add 10.0.1.1/24 dev eth0`
* **`host-2`:** `ip addr add 10.0.1.2/24 dev eth0`

### 2. Mode A: Unicast VXLAN (Head-End Replication)

In this mode, the VXLAN Tunnel Endpoints (VTEPs) explicitly point to the remote peer's underlay IP address. While this works perfectly for point-to-point tunnels, it places the burden of replicating BUM traffic entirely on the router's software CPU.

**VTEP Core Logic:**

```bash
# create the vxlan iface pointing at rt2
ip link add vxlan10 type vxlan id 10 remote 10.0.0.2 dstport 4789

ip link add br0 type bridge # virtual switch
ip link set eth1 master br0 # br0 port1: host-end
ip link set vxlan10 master br0 # br0 port2: 10.0.0.0/30
```

<img src="./tp06-bgp-doors-p2/screenshots/tp06-rt1-ifaces.png" />
<img src="./tp06-bgp-doors-p2/screenshots/tp06-rt1-vxlan10-unicast.png" />


### 3. Mode B: Multicast VXLAN

In this mode, BUM traffic is encapsulated and forwarded to a dedicated multicast group (`239.1.1.1`). Any VTEP subscribed to this group automatically receives the broadcast, allowing the physical network hardware to handle the replication efficiently at scale.

**VTEP Core Logic:**

```bash
ip link add vxlan10 type vxlan id 10 group 239.1.1.1 dev eth0 dstport 4789

ip link add br0 type bridge
ip link set eth1 master br0
ip link set vxlan10 master br0
```

<img src="./tp06-bgp-doors-p2/screenshots/tp06-vxlan10-multicast.png" />

## Automated Deployment

`./configure-unicast`: deploys the Unicast overlay.<br/>
`./configure-multicast`: deploys the Multicast overlay.

## Verification & Packet Analysis

### 1. End-to-End Connectivity

To verify the overlay is functioning, a standard Layer 2 ping is initiated from `host-1` to `host-2`:

```
ping 10.0.1.2
```

<img src="./tp06-bgp-doors-p2/screenshots/tp06-ping-success.png" />

### 2. Wireshark Capture Inspection

<img src="./tp06-bgp-doors-p2/screenshots/tp06-capture.png" />

1. **The ARP Broadcast:** `host-1` issues a standard Layer 2 ARP request (`Who has 10.0.1.2?`).
2. **The VXLAN Header:** The `br0` switch pushes the ARP frame into the `vxlan10` engine. The packet capture clearly shows the frame wrapped in a UDP header targeting port `4789`, with the `VXLAN Network Identifier (VNI): 10` explicitly defined in the payload.
3. **The Underlay Illusion:** The subsequent ICMP Echo Requests and Replies are also perfectly encapsulated. From the perspective of the transit network, it only sees standard UDP traffic flowing between `10.0.0.1` and `10.0.0.2`.
