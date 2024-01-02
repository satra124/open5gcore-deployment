FROM ubuntu:focal

MAINTAINER Fatih Nar <fenari@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
   apt-get -yq dist-upgrade && \
   apt-get --no-install-recommends -qqy install python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev \
   libidn11-dev libmongoc-dev libbson-dev libyaml-dev libmicrohttpd-dev libcurl4-gnutls-dev meson iproute2 libnghttp2-dev \
   iptables iputils-ping tcpdump cmake curl gnupg meson && \ 
   git clone --recursive -b v2.2.2 https://github.com/open5gs/open5gs && \
   cd open5gs && meson build --prefix=/ && ninja -C build && cd build && ninja install

WORKDIR /
