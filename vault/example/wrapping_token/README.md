### Token with ttl
* create token
```bash
export USERNAME=myaccount
export POLICY=mypolicy
export TTL=168h

vault token create \
 --ttl ${TTL} -display-name=${USERNAME}-readonly \
 -policy=application \
 -policy=${POLICY} \
 -wrap-ttl=${TTL}

Key                              Value
---                              -----
wrapping_token:                  s.3yfhrauz7XmvGvsJSjQOztxg
wrapping_accessor:               9r2S3mrt5DkEMNWz2yS9IWsw
wrapping_token_ttl:              168h
wrapping_token_creation_time:    2021-06-23 08:22:57.454404848 +0000 UTC
wrapping_token_creation_path:    auth/token/create
wrapped_accessor:                shaD3TR5auS1aokgcZZ9Cr0V
```
* unwrap token
```bash
vault unwrap s.3yfhrauz7XmvGvsJSjQOztxg
Key                  Value
---                  -----
token                s.QLA79YiAeKSxIxXtKyJkz6RV
token_accessor       shaD3TR5auS1aokgcZZ9Cr0V
token_duration       168h
token_renewable      true
token_policies       ["application" "mypolicy" "default"]
identity_policies    []
policies             ["application" "mypolicy" "default"]
```
* Test login
```bash
export VAULT_TOKEN=s.QLA79YiAeKSxIxXtKyJkz6RV
vault login s.QLA79YiAeKSxIxXtKyJkz6RV
```

* revoke wrapping_token
```bash
vault token revoke -accessor shaD3TR5auS1aokgcZZ9Cr0V
```
