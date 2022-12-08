## Docker image
```bash
docker build -t consulate .
docker run -d --rm --name consulate -v $(pwd):/data consulate tail -f /dev/null
docker exec -ti consulate bash
```

## Backup consul kv store
```bash
consulate --api-scheme http --api-host localhost --api-port 80 kv backup -f kv.`date +%Y%m%d`.json
```

## Restore consul kv store
```bash
consulate --api-scheme http --api-host localhost --api-port 80 kv restore -f kv.`date +%Y%m%d`.json
```

## Reference
* [consulate](https://github.com/gmr/consulate)
