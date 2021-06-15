### Travis CI
```yaml
before_install:
  - export DOCKLE_VERSION=$(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  - curl -LO https://github.com/goodwithtech/dockle/releases/download/v${DOCKLE_VERSION}/dockle_${DOCKLE_VERSION}_Linux-64bit.tar.gz
  - tar zxvf dockle_${DOCKLE_VERSION}_Linux-64bit.tar.gz

script:
  - ./dockle --exit-code 0 --exit-level fatal <docker image>
```

### Reference
* [dockle](https://github.com/goodwithtech/dockle)
