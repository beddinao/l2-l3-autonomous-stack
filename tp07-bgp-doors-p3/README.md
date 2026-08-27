# *`Topology 07: BGP EVPN Control Plane`*

## Objective

The goal of this topology is to deploy a dynamic Layer 2 overlay using BGP EVPN (Ethernet Virtual Private Network) as the control plane. It utilizes a Spine-Leaf architecture with an iBGP Route Reflector to dynamically distribute MAC addresses (Route Type 2) and VTEP endpoints (Route Type 3) without relying on static head-end replication or underlay multicast.

## Topology Architecture

<img width="1209" height="787" alt="tp07-screen0" src="https://github.com/user-attachments/assets/6a457d8b-498f-423e-87f2-f83be122bc98" />

**Layer 3 Underlay:** Point-to-point transit links and loopbacks for OSPF and BGP.

* `router-1` (Spine/RR): `1.1.1.1/32` (`lo`), `10.0.1.1/30` (`eth0`), `10.0.2.1/30` (`eth1`), `10.0.3.1/30` (`eth2`).
* `router-2` (Leaf 1): `1.1.1.2/32` (`lo`), `10.0.1.2/30` (`eth0`).
* `router-3` (Leaf 2): `1.1.1.3/32` (`lo`), `10.0.2.2/30` (`eth0`).
* `router-4` (Leaf 3): `1.1.1.4/32` (`lo`), `10.0.3.2/30` (`eth0`).

**Layer 2 Overlay:** The stretched virtual network for the endpoints.

* `host-1`: `10.1.1.1/24` (`eth0`).
* `host-2`: `10.1.1.2/24` (`eth0`).
* `host-3`: `10.1.1.3/24` (`eth0`).

**VXLAN Tunnel Attributes:**

* **VNI:** `10`.
* **UDP Destination Port:** `4789`.

## Configuration Details

The setup utilizes local Bash scripts executed dynamically inside the Docker containers to apply the IP, bridge, and FRRouting configurations.

### 1. Host Configuration

All hosts exist on the same `/24` subnet, remaining entirely unaware of the Layer 3 underlay.

* **`host-1`:** `ip addr add 10.1.1.1/24 dev eth0`
* **`host-2`:** `ip addr add 10.1.1.2/24 dev eth0`
* **`host-3`:** `ip addr add 10.1.1.3/24 dev eth0`

### 2. Spine Configuration (Route Reflector)

The Spine routes the physical underlay via OSPF and acts as a central iBGP Route Reflector for the EVPN address family.

**Spine Core Logic:**

```bash
# OSPF 
vtysh -c 'configure terminal' \
  -c 'router ospf' \
  -c 'network 1.1.1.1/32 area 0' \
  -c 'network 10.0.1.0/30 area 0' \
  -c 'network 10.0.2.0/30 area 0' \
  -c 'network 10.0.3.0/30 area 0' \

# BGP EVPN RR
  -c 'router bgp 1' \
  -c 'bgp router-id 1.1.1.1' \
  -c 'neighbor 1.1.1.2 remote-as 1' \
  -c 'neighbor 1.1.1.2 update-source lo' \
  -c 'address-family l2vpn evpn' \
  -c 'neighbor 1.1.1.2 activate' \
  -c 'neighbor 1.1.1.2 route-reflector-client' \
  # (Repeated for neighbors 1.1.1.3 and 1.1.1.4)
```

### 3. Leaf Configuration (VTEPs)

The VXLAN interface is created without specifying a remote IP or multicast group. BGP handles the dynamic discovery of remote VTEPs and MAC addresses.

**VTEP Core Logic:**

```bash
# vxlan iface
ip link add vxlan10 type vxlan id 10 dstport 4789

ip link add br0 type bridge # virtual switch
ip link set eth1 master br0 # br0 port1: host-end
ip link set vxlan10 master br0 # br0 port2: VTEP

# kernel FDB to BGP EVPN
vtysh -c 'configure terminal' \
  -c 'router bgp 1' \
  -c 'neighbor 1.1.1.1 remote-as 1' \
  -c 'neighbor 1.1.1.1 update-source lo' \
  -c 'address-family l2vpn evpn' \
  -c 'neighbor 1.1.1.1 activate' \
  -c 'advertise-all-vni'
```

## Verification & Packet Analysis

### 1. Control Plane Synchronization

To verify the control plane, check the EVPN routing table on any Leaf router:

```
vtysh -c "show bgp l2vpn evpn"
```

* **Route Type 3:** Appears immediately upon BGP adjacency, confirming VTEP discovery.
* **Route Type 2:** Appears dynamically once the hosts are active and the local bridge learns their MAC addresses.

### 2. End-to-End Connectivity

A standard Layer 2 ping initiated from `host-1` to `host-3`:

```
ping 10.1.1.3
```

## Automated Deployment

`./configure-tp07`: deploys the full Spine-Leaf overlay.</br>
`./rtx-display-cnfs`: executes a suite of verification commands (`show running-config`, `show ip ospf neighbor`, `show bgp l2vpn evpn`) across all routers.
