from centos

RUN dnf install -y jq vim python38
WORKDIR /apps
RUN curl -qLo /usr/local/bin/spin https://storage.googleapis.com/spinnaker-artifacts/spin/$(curl -s https://storage.googleapis.com/spinnaker-artifacts/spin/latest)/linux/amd64/spin
RUN chmod +x /usr/local/bin/spin
RUN mkdir /root/.spin/
ADD . /apps/
ADD spin.conf /root/.spin/config
CMD ["tail", "-f", "/dev/null"]
