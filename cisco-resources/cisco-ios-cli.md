# *`Cisco IOS CLI cheat sheet`*

### MODES

```text
- >            : User EXEC mode[cite: 1]
- #            : Privileged EXEC mode[cite: 1]
- (config)#    : Global configuration mode[cite: 1]
- (config-if)# : Interface configuration mode[cite: 1]

```

### PASSWORDS

```text
- (config)# enable password <password> : Set plain text password to <password>[cite: 1]
- (config)# service password-encryption : Use Cisco's Type 7 encoding[cite: 1]
- (config)# enable secret <password> : Set MD5 hashed password to <password> and disable old passwords[cite: 1]

```

### BASICS

```text
- > enable : Change to Privileged EXEC mode[cite: 1]
- exit : Exit current mode[cite: 1]
- <text>? : Show possible commands for the current mode starting with <text>[cite: 1]
- <command> ? : Show possible options to complete the <partial_command> command with[cite: 1]
- no <command> : Disable a feature/function or reverse the action of <command>[cite: 1]
- do <command> : Run <command> in Privileged EXEC mode[cite: 1]
- # configure terminal : Enter Privilleged EXEC mode[cite: 1]
- # show running-config : Show current config[cite: 1]
- # show startup-config : Show startup config[cite: 1]
- # write : Save running-config as startup-config[cite: 1]
- # write memory : Save running-config as startup-config[cite: 1]
- # copy running-config startup-config : Save running-config as startup-config[cite: 1]
- # ping <ip_address> : Ping <ip_address>[cite: 1]
- # show mac address-table : Show the MAC address table[cite: 1]
- # show arp : View the ARP table and show all ARP entries[cite: 1]
- # show ip interface brief : Show interfaces status and configured IP addresses[cite: 1]
- # show interfaces status : Show L2 nad L3 info about the interfaces and their status[cite: 1]
- # show interfaces <interface> : Show all available info about <interface> interface[cite: 1]
- # show ip route : View routing rable[cite: 1]
- (config)# shutdown : Disable interface[cite: 1]
- (config)# clear mac address-table : Manually clear the MAC address table[cite: 1]
- (config)# clear mac address-table dynamic <interface> : Clear MAC address table entry for <interface> interface[cite: 1]
- (config)# interface <interface_name> : Enter <interface_name> config mode[cite: 1]
- (config)# interface range <interface_start> - <interface_stop> : Enter interface config mode for all interfaces (including) <interface_start> through <interface_stop>[cite: 1]
- (config)# ip route <ip_address> <netmask> <next_hop> : Add static route to routing table[cite: 1]
- (config)# ip route <ip_address> <netmask> <exit_interface> : Add static route to routing table using only the interface name[cite: 1]
- (config)# ip route <ip_address> <netmask> <exit_interface> <next_hop> : Add static route to routing table using interface name and next-hop[cite: 1]
- (config-if)# ip address <ip_address> <subnet_mask> : Configure interface IP address[cite: 1]
- (config-if)# speed <speed> : Manually configure interface/s speed[cite: 1]
- (config-if)# duplex <duplex> : Manually configure interface/s duplex[cite: 1]
- (config-if)# description <text description> : Set the description field for the interface to <text description>[cite: 1]

```
