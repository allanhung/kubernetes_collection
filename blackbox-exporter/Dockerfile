ARG ARCH="amd64"
ARG OS="linux"

FROM golang:1.16.0 AS build
ARG BLACKBOX_VERSIONTAG="v0.19.0"
ENV ARCH=linux
ENV CGO_ENABLED=0
RUN apt-get update && apt-get install -y patch
RUN mkdir -p /go/src/github.com/prometheus
RUN cd /go/src/github.com/prometheus && git clone -b ${BLACKBOX_VERSIONTAG} --depth 1 https://github.com/prometheus/blackbox_exporter
WORKDIR /go/src/github.com/prometheus/blackbox_exporter
COPY blackbox_exporter.json.patch .
RUN patch -p1 < blackbox_exporter.json.patch
RUN go mod tidy
RUN make build

FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

COPY --from=build ./go/src/github.com/prometheus/blackbox_exporter/blackbox_exporter  /bin/blackbox_exporter
COPY --from=build ./go/src/github.com/prometheus/blackbox_exporter/blackbox.yml       /etc/blackbox_exporter/config.yml

EXPOSE      9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
