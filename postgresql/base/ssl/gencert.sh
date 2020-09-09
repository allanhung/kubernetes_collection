openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/CN=certificate-authority"
openssl genrsa -out server.key 4096
openssl req -new -nodes -sha256 -key server.key -out server.csr -subj "/CN=postgres"
openssl x509 -req -sha256 -in server.csr -days 3650 -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt 
chmod 600 *.key *.crt
