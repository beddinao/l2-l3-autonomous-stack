# *`Docker Environment Setup`*

## Objective

The goal of this part is to establish the foundational Docker containers used throughout the project. It defines the base images for both the routing nodes and the end hosts within the GNS3 environment.

## Components

* **`router.dockerfile`:** Builds an Alpine 3.23 based image equipped with the FRRouting (FRR) suite and Python tools. It is configured to automatically enable the `zebra`, `ospfd`, `bgpd`, and `isisd` daemons and execute the FRR initialization script upon container launch.


* **`host.dockerfile`:** Builds a lightweight Alpine 3.23 based endpoint containing basic networking and terminal utilities, including `busybox`, `bash`, and `xfce4-terminal`.


* **`vimrc`:** A customized Vim configuration file injected into both containers to provide line numbers and standard formatting for terminal text editing.


* **`P1.gns3project`:** The baseline GNS3 project file used for deploying these initial container nodes.
