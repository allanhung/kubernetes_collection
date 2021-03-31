### Installation (Mac)
```bash
brew install kind
```

### Example
* create cluster
```bash
kind create cluster
```
* upload custom image
```bash
cat > Dockerfile << EOF
FROM debian:buster-slim

CMD ["sleep", "9999"]
EOF
docker build -t sleep:0.1.0 .
kind load docker-image sleep:0.1.0
cat > sleep.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: sleep
spec:
  containers:
  - name: sleep
    image: sleep:0.1.0
EOF
kubectl apply -f sleep.yaml
```
