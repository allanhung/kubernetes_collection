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
dnf install -y epel-release
dnf install -y dnsperf xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part01.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part02.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part03.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part04.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part05.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part06.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part07.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part08.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part09.xz
curl -LO https://github.com/DNS-OARC/sample-query-data/raw/main/queryfile-example-10million-201202_part10.xz
xz -d -v queryfile-example-10million-201202_part*.xz
cat queryfile-example-10million-201202_part* > queryfile-example-10million-201202
# Query server 127.0.0.1 (using the sample query file) for 60 seconds from 1 client with 10 requests/sec
dnsperf -s 127.0.0.1 -d queryfile-example-10million-201202 -l 60 -c 1 -Q 10
```
### read udp i/o timeout
https://github.com/coredns/coredns/blob/master/plugin/forward/forward.go#L97
```
deadline := time.Now().Add(defaultTimeout)
```

### Reference
* [coredns](https://github.com/coredns/coredns)
* [coredns helm chart](https://github.com/coredns/helm)
* [dnsperf](https://www.dns-oarc.net/tools/dnsperf)

