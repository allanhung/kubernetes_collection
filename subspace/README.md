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
  -f ./values.yaml \
  ./chart
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
