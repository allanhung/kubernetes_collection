from centos:8

RUN yum install -y golang git vim
RUN go get github.com/spf13/cobra
RUN go get github.com/coreos/go-oidc
RUN go get golang.org/x/oauth2
WORKDIR /dex-app
COPY *.go /dex-app/
COPY *.patch /dex-app/
RUN go build .

ENTRYPOINT ["/dex-app/dex-app", "--listen", "http://0.0.0.0:5555"]
