# Installation
DirectPV comes with two components:
1. DirectPV plugin - installed on client machine.
2. DirectPV CSI driver - installed on Kubernetes cluster.

## DirectPV plugin installation
The plugin needs to be installed to manage DirectPV CSI driver in Kubernetes.

### Prerequisites
* Access to Kubernetes cluster.

### Installation using `Krew`
The latest DirectPV plugin is available in `Krew` repository. Use below steps to install the plugin in your system.
```sh
# Update the plugin list.
$ kubectl krew update

# Install DirectPV plugin.
$ kubectl krew install directpv
```

### Installation of release binary
The plugin binary name starts by `kubectl-directpv` and is available at https://github.com/minio/directpv/releases/latest. Download the binary as per your operating system and architecture. Below is an example for `GNU/Linux` on `amd64` architecture:

```sh
# Download DirectPV plugin.
$ release=$(curl -sfL "https://api.github.com/repos/minio/directpv/releases/latest" | awk '/tag_name/ { print substr($2, 3, length($2)-4) }')
$ curl -fLo kubectl-directpv https://github.com/minio/directpv/releases/download/v${release}/kubectl-directpv_${release}_linux_amd64

# Make the binary executable.
$ chmod a+x kubectl-directpv
```

## DirectPV CSI driver installation
Before starting the installation, it is required to have DirectPV plugin installed on your system. For plugin installation refer [this documentation](#directpv-plugin-installation). If you are not using `krew`, replace `kubectl directpv` by `kubectl-directpv` in below steps.

### Helm installation
Run generate.sh to generate helm chart.
