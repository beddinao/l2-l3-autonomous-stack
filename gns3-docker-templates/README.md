# *`Docker Environment Setup`*

the base images for both the routing nodes and the end hosts within the GNS3 environment.

## Components

* **`router.dockerfile`:** Builds an Alpine based image equipped with the FRRouting (FRR) suite and Python tools. It is configured to automatically enable the `zebra`, `ospfd`, `bgpd`, and `isisd` daemons and execute the FRR initialization script upon launch (tp06 and tp07).

* **`host.dockerfile`:** Builds a lightweight Alpine 3.23 based endpoint containing basic networking and terminal utilities, including `busybox`, `bash`, and `xfce4-terminal`.

* **`P1.gns3project`:** The baseline GNS3 project file used for deploying these initial container nodes.
