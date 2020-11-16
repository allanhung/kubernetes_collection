### Compile
```bash
docker build -t my-dex-client:0.0.1 .
```

### Run
```bash
docker run -d --name dex-client --rm -p 5555:5555 my-dex-client:0.0.1 --issuer https://<issuer> --redirect-uri http://127.0.0.1:5555/callback --client-id my-client-id --client-secret my-client-secret --listen http://0.0.0.0:5555 --debug
```

### Test auth
```bash
curl 'https://<my-issuer>/auth?client_id=<my-client-id>&scope=openid%20groups%20profile%20email&response_type=id_token&redirect_uri=https%3A%2F%2F127.0.0.1%3A5555%2Fcallback&nonce=hellononce'
```

## Reference
* [example-app](https://github.com/dexidp/dex/tree/master/examples/example-app)
