FROM golang:1.16.0 AS build
ENV ARCH=linux
ENV CGO_ENABLED=0

RUN apt-get update && apt-get install -y git make
WORKDIR /go/src/github.com/jaegertracing/jaeger
COPY . .
RUN git submodule update --init --recursive
RUN make install-tools
RUN go build -tags ui -o jarger-query cmd/query/main.go

FROM alpine:3.12.1
RUN apk --no-cache add \
    ca-certificates \
    tzdata \
    iptables
COPY --from=build /go/src/github.com/jaegertracing/jaeger/jarger-query /bin/jarger-query
ENTRYPOINT ["jarger-query"]
