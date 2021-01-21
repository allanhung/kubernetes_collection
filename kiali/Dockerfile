FROM golang:1.15 AS build
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GOPATH=/go
RUN mkdir -p /go/src/github.com/kiali
WORKDIR /go/src/github.com/kiali
RUN git clone -b v1.28.1 --depth 1 https://github.com/kiali/kiali
WORKDIR /go/src/github.com/kiali/kiali
#COPY kiali /go/src/github.com/kiali/kiali
RUN make build

FROM centos:8
RUN yum install -y vim
RUN adduser -p '' --uid 1000 kiali
WORKDIR /opt/kiali/console
RUN curl -LO https://registry.npmjs.org/@kiali/kiali-ui/-/kiali-ui-1.28.0.tgz
RUN echo "1.28.0" > version.txt && tar -zxf kiali-ui-1.28.0.tgz && mv package/build/* /opt/kiali/console/  && rm -f kiali-ui-1.28.0.tgz rm -rf package
WORKDIR /opt/kiali
COPY --from=build /go/bin/kiali /opt/kiali/kiali
RUN chown -R kiali:kiali /opt/kiali/console && chmod -R g=u /opt/kiali/console
USER 1000

ENTRYPOINT ["/opt/kiali/kiali"]
