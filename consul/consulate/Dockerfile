from quay.io/centos/centos:stream9

RUN dnf install -y python3-pip git vim
RUN pip3 install consulate
WORKDIR /data
CMD ["tail", "-f", "/dev/null"]
