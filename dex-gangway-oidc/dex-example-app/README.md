### Download code
```bash
curl -LO https://raw.githubusercontent.com/dexidp/dex/v2.27.0/examples/example-app/main.go
curl -LO https://raw.githubusercontent.com/dexidp/dex/v2.27.0/examples/example-app/templates.go
patch < requestType.patch
```

### Compile
```bash
docker build -t my-dex-client:0.0.1 .
```

### Run
```bash
export ISSUER=dex.my-domain.com
export MYCLIENT=my-client-id
export MYSECRET=1234567890123456
docker run -d --name dex-client --rm -p 5555:5555 my-dex-client:0.0.1 --issuer https://${ISSUER} --redirect-uri http://127.0.0.1:5555/callback --client-id ${MYCLIENT} --client-secret ${MYSECRET} --listen http://0.0.0.0:5555 --debug
```

### Test auth
```bash
curl 'https://'${ISSUER}'/auth?client_id='${MYCLIENT}'&scope=openid%20groups%20profile%20email&response_type=id_token&redirect_uri=http%3A%2F%2F127.0.0.1%3A5555%2Fcallback&nonce=hellononce'
```

## Reference
* [example-app](https://github.com/dexidp/dex/tree/master/examples/example-app)
