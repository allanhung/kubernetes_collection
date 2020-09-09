FROM golang:1.14 AS build
ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=amd64
ENV GOPATH=/go
RUN go get -d -u github.com/grafana/loki || echo "ignore go get error"
RUN go get -d -u github.com/allanhung/fluent-bit-out-syslog/cmd 
WORKDIR /go/src/github.com/grafana/loki
RUN make clean && make fluent-bit-plugin
WORKDIR /go/src/github.com/allanhung/fluent-bit-out-syslog
RUN rm -f go.mod go.sum && go build -buildmode c-shared -o out_syslog.so cmd/main.go

FROM fluent/fluent-bit:1.4.5
COPY --from=build /go/src/github.com/grafana/loki/cmd/fluent-bit/out_loki.so /usr/lib/x86_64-linux-gnu/
COPY --from=build /go/src/github.com/allanhung/fluent-bit-out-syslog/out_syslog.so /usr/lib/x86_64-linux-gnu/
COPY conf/fluent-bit.conf \
     conf/parsers.conf \
     conf/parsers_java.conf \
     conf/parsers_extra.conf \
     conf/parsers_openstack.conf \
     conf/parsers_cinder.conf \
     conf/out_loki.conf \
     conf/out_syslog.conf \
     conf/plugins.conf \
     /fluent-bit/etc/

EXPOSE 2020

# Entry point
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf", "-e", "/usr/lib/x86_64-linux-gnu/out_loki.so", "-e", "/usr/lib/x86_64-linux-gnu/out_syslog.so"]
