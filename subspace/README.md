### Build centos 7 image
```bash
git clone --depth 1 https://github.com/subspacecommunity/subspace
patch -p1 < centos7.patch
cd subspace
docker build -t allanhung/subspace:v1.5.0 .
docker push allanhung/subspace:v1.5.0 .
```

### Upgrade / Install to kubernetes
```bash
helm upgrade --install subspace \
  -n infra \
  --create-namespace \
  -f ./chart/values.yaml \
  ./chart
```

### Install in vm
```bash
mkdir -p /opt/wiregurad/data/wireguard/clients
mkdir -p /opt/wiregurad/data/wireguard/peers
mkdir -p /opt/wiregurad/data/wireguard/iptables
mkdir -p /opt/wiregurad/data/wireguard/iptables-cleanup
touch /opt/wiregurad/data/wireguard/clients/null.conf
touch /opt/wiregurad/data/wireguard/peers/null.conf
touch /opt/wiregurad/data/wireguard/iptables-cleanup/null.sh
touch /opt/wiregurad/data/wireguard/iptables/null.sh
wg genkey | tee /opt/wiregurad/data/wireguard/server.private | wg pubkey > /opt/wiregurad/data/wireguard/server.public
docker run -d --name=wg --rm --privileged \
        -e SUBSPACE_ALLOWED_IPS="0.0.0.0/1,128.0.0.0/5,136.0.0.0/7,139.0.0.0/8,140.0.0.0/6,144.0.0.0/4,160.0.0.0/3,192.0.0.0/2" \
        -e SUBSPACE_BACKLINK=/ \
        -e SUBSPACE_DISABLE_DNS="1" \
        -e SUBSPACE_ENDPOINT_HOST="138.2.62.99" \
        -e SUBSPACE_HTTP_ADDR=":58080" \
        -e SUBSPACE_HTTP_HOST="138.2.62.99" \
        -e SUBSPACE_HTTP_INSECURE="false" \
        -e SUBSPACE_IPV4_GW="10.99.97.1" \
        -e SUBSPACE_IPV4_NAT_ENABLED="1" \
        -e SUBSPACE_IPV4_POOL="10.99.97.0/24" \
        -e SUBSPACE_IPV6_GW="fd00::10:97:1" \
        -e SUBSPACE_IPV6_NAT_ENABLED="0" \
        -e SUBSPACE_IPV6_POOL="fd00::10:97:0/64" \
        -e SUBSPACE_LETSENCRYPT="false" \
        -e SUBSPACE_LISTENPORT="51820" \
        -e SUBSPACE_NAMESERVERS="1.1.1.1,8.8.8.8" \
        -e SUBSPACE_HTTP_INSECURE="true" \
        -v /opt/wiregurad/data:/data \
        -v /usr/src:/host/usr/src \
        -v /lib/modules:/lib/modules \
        -p 58080:58080 \
        -p 51820:51820 \
        docker.quid.com/quid/subspace:v1.5.0
```
### Run in vm
```
export SUBSPACE_ALLOWED_IPS="0.0.0.0/1,128.0.0.0/5,136.0.0.0/7,139.0.0.0/8,140.0.0.0/6,144.0.0.0/4,160.0.0.0/3,192.0.0.0/2"
export SUBSPACE_BACKLINK=/
export SUBSPACE_DISABLE_DNS="1"
export SUBSPACE_ENDPOINT_HOST="138.2.62.99"
export SUBSPACE_HTTP_ADDR=":58080"
export SUBSPACE_HTTP_HOST="138.2.62.99"
export SUBSPACE_HTTP_INSECURE="false"
export SUBSPACE_IPV4_GW="10.99.97.1"
export SUBSPACE_IPV4_NAT_ENABLED="1"
export SUBSPACE_IPV4_POOL="10.99.97.0/24"
export SUBSPACE_IPV6_GW="fd00::10:97:1"
export SUBSPACE_IPV6_NAT_ENABLED="0"
export SUBSPACE_IPV6_POOL="fd00::10:97:0/64"
export SUBSPACE_LETSENCRYPT="false"
export SUBSPACE_LISTENPORT="51820"
export SUBSPACE_NAMESERVERS="1.1.1.1,8.8.8.8"
export SUBSPACE_HTTP_INSECURE="true"
```

### Reference
#### wiregurad
* [wireguard](https://www.wireguard.com/)
* [Linux-setup](https://github.com/zjuchenyuan/notebook/blob/master/Linux-setup.md)
#### wiregurad UI
* [wg-gen-web](https://github.com/vx3r/wg-gen-web)
* [wg-ui](https://github.com/EmbarkStudios/wg-ui)
* [wireguard-ui](https://github.com/ngoduykhanh/wireguard-ui)
* [subspace](https://github.com/subspacecloud/subspace)
* [subspace-community](https://github.com/subspacecommunity/subspace)
* [wg-manager](https://github.com/perara/wg-manager)
* [mistborn](https://gitlab.com/cyber5k/mistborn)
* [firezone](https://github.com/firezone/firezone)
#### wiregurad tools
* [wg-api](https://github.com/jamescun/wg-api)
* [wireguard-tools](https://git.zx2c4.com/wireguard-tools)
* [subspace repo](https://github.com/allanhung/subspace/tree/centos)
