## *`Topology 05: OSPF Underlay and Dynamic Convergence`*

<img width="1282" height="779" alt="tp05-screen0" src="https://github.com/user-attachments/assets/d09b6881-f929-4036-b7f3-d13f15386325" />


#### OVERVIEW
```text
This topology establishes a highly available Layer 3 routing underlay. By migrating from 
static routing to the Open Shortest Path First (OSPF) dynamic routing protocol, the infrastructure 
gains the ability to autonomously map its own topology. This architecture demonstrates link-state 
database synchronization, secure route injection, and sub-second path recalculation during 
physical hardware failures.
```

#### PART 01, INFRASTRUCTURE and ACCESS OPTIMIZATION

```text
- Deploys a triangular core of three Cisco IOSv routers (RT1, RT2, RT3) acting as the OSPF Area 0 backbone.
- RT2 and RT3 serve as edge routers, connecting the transit backbone to local access networks 
  (10.0.10.0/24 and 10.0.20.0/24).
- Optimizes the Layer 2 access switches by configuring "spanning-tree portfast" on the host-facing ports.
- This configuration bypasses the standard 30-second STP Listening/Learning phases, immediately 
  transitioning the edge ports to Forwarding state. The console explicitly warns that this must 
  never be used on switch-to-switch links to prevent bridging loops.
```

<img width="1024" height="309" alt="tp05-switch-cnf" src="https://github.com/user-attachments/assets/b95d219f-2d44-455b-b70b-d3a97df7707d" />


#### PART 02, OSPF CONTROL PLANE and ADJACENCY

```text
- Initializes the OSPF process (PID 1) on all routers.
- To guarantee control plane stability, virtual Loopback0 interfaces (1.1.1.1, 2.2.2.2, 3.3.3.3) 
  are created and explicitly hardcoded as the OSPF Router IDs (RID).
- The transit links between routers use /30 point-to-point subnets to conserve IPv4 space.
- Routers multicast Hello packets to 224.0.0.5 to discover neighbors. The packet capture proves 
  successful Hello exchange, allowing routers to transition to the FULL adjacency state.
```

<img width="927" height="352" alt="tp05-RT2-RT3-ospf-hello-capture" src="https://github.com/user-attachments/assets/b9ef60cb-7d62-492a-9bfc-c29fff6a64b9" />


```
- Verifies successful OSPF neighbor discovery and database synchronization,
  achieving the FULL adjacency state alongside automatic DR/BDR role elections.
```

<img width="958" height="262" alt="tp05-ospf-neighbor-on-RT1" src="https://github.com/user-attachments/assets/eaa72221-e0f8-44f4-b651-3cd5a7f77478" />
<img width="958" height="260" alt="tp05-ospf-neighbor-on-RT2" src="https://github.com/user-attachments/assets/dd349f80-b3c6-437e-8dda-fd93d34f04b3" />




#### PART 03, EDGE SECURITY and ROUTE INJECTION

```text
- RT2 and RT3 must advertise their respective LAN subnets to the OSPF domain securely.
- Applies the "passive-interface" command to the router ports facing the user LANs (Gi0/3).
- This critical security measure injects the local subnets (10.0.10.0/24 and 10.0.20.0/24) into 
  the master Link-State Database, but strictly blocks the router from transmitting OSPF Hello 
  multicasts down to the endpoints, preventing malicious route injection.
- The routing table confirms RT2 successfully learned the dynamic OSPF route (marked with 'O') 
  to the remote 10.0.20.0/24 subnet.
```

<img width="958" height="343" alt="tp05-ospf-routes-on-RT2" src="https://github.com/user-attachments/assets/3698bf86-7aea-4b4f-bf29-0300fb579a90" />


#### PART 04, DYNAMIC CONVERGENCE and FAILOVER

```text
- Validates the autonomous self-healing capabilities of the link-state algorithm.
- INITIAL STATE: A traceroute from host-1 to host-4 takes the mathematically shortest path 
  directly across the bottom link (host-1 -> RT2 -> RT3 -> host-4).
```

<img width="958" height="295" alt="tp05-traceroute-from-net10-to-net20-0" src="https://github.com/user-attachments/assets/d79ee578-7fc8-4603-a157-0f04b06905af" />


```
- FAULT INJECTION: The primary physical link connecting RT2 and RT3 is PAUSED.
```

<img width="991" height="215" alt="tp05-RT2-to-RT3-link-pause" src="https://github.com/user-attachments/assets/3dff1481-4d57-4638-b144-fdf922ec4340" />


```
- CONVERGENCE: OSPF instantly detects the dead link, flushes the stale route, recalculates 
  Dijkstra's algorithm against its database, and dynamically re-routes traffic through the 
  Apex router (RT1).
- NEW STATE: A follow-up traceroute proves traffic now seamlessly travels the backup path 
  (host-1 -> RT2 -> RT1 -> RT3 -> host-4) with zero manual intervention.
```

<img width="959" height="259" alt="tp05-traceroute-from-net10-to-net20-2" src="https://github.com/user-attachments/assets/202f3c9a-aa3d-41f1-8f81-79d58256c290" />

