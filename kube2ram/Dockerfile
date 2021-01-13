FROM golang:1.15 AS build
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GOPATH=/go
RUN go get -d -u github.com/AliyunContainerService/kube2ram
WORKDIR /go/src/github.com/AliyunContainerService/kube2ram
RUN go build -o kube2ram cmd/main.go

FROM alpine:3.9
RUN apk --no-cache add \
    ca-certificates \
    tzdata \
    iptables
COPY --from=build /go/src/github.com/AliyunContainerService/kube2ram/kube2ram /bin/kube2ram
ENTRYPOINT ["/bin/kube2ram"]
