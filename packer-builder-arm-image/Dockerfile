FROM golang:buster AS builder
RUN apt-get update -qq \
 && apt-get install -qqy git && \
 mkdir /build

WORKDIR /build

# if you wish to build from upstream, un comment this line, and comment lines below
# RUN git clone --depth 1 https://github.com/solo-io/packer-builder-arm-image /build

# if you wish to build from upstream, comment from here.
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# if you wish to build from upstream, comment up to here.

RUN go build -o packer-builder-arm-image

FROM ubuntu:eoan

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
  qemu-user-static \
  kpartx \
  unzip \
  wget \
  curl \
  sudo \
 && rm -rf /var/lib/apt/lists/*

ENV PACKER_VERSION 1.5.4
# use nightly release until packer 1.5.2 is released

RUN curl -# "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" > /tmp/packer.zip && \
  unzip /tmp/packer.zip -d /bin && \
  rm /tmp/packer.zip
WORKDIR /build
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=builder /build/packer-builder-arm-image /bin/packer-builder-arm-image
ENTRYPOINT ["/entrypoint.sh"]
