kubectl -n kube-system edit cm eni-config
  10-terway.conf: |
    {
      "cniVersion": "0.3.1",
      "name": "terway",
      "capabilities": {"bandwidth": true},

      "type": "terway"
    }
  in_cluster_loadbalance: "true"

kubectl -n kube-system patch ds terway-eniip --record --type='json' -p '[
  {
    "op": "replace",
    "path": "/spec/template/spec/initContainers/0/command",
    "value":  ["/bin/init.sh"]
  }
]'
kubectl -n kube-system delete pods -l app=terway-eniip
