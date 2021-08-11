### Installation
```bash
helm repo add coredns https://coredns.github.io/helm

helm upgrade --install coredns \
  -n kube-system \
  -f ./values.yaml \
  coredns/coredns
```

### DNS Benchmark
```bash
dnf install -y dnsperf
curl -LO https://www.dns-oarc.net/files/dnsperf/data/queryfile-example-10million-201202.gz
gnuzip queryfile-example-10million-201202.gz
# Query server 127.0.0.1 (using the sample query file) for 60 seconds from 1 client with 10 requests/sec
dnsperf -s 127.0.0.1 -d queryfile-example-10million-201202 -l 60 -c 1 -Q 10
```

### Reference
* [coredns](https://github.com/coredns/coredns)
* [coredns helm chart](https://github.com/coredns/helm)
* [dnsperf](https://www.dns-oarc.net/tools/dnsperf)

