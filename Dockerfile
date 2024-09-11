FROM debian:stable-slim

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get -y install git cmake gcc g++ make pkgconf libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git && cd SoftEtherVPN && git submodule init && git submodule update

ENV CMAKE_FLAGS="-DSE_PIDDIR=/run/softether -DSE_LOGDIR=/var/log/softether -DSE_DBDIR=/var/lib/softether"
RUN cd /SoftEtherVPN && ./configure && make -j5 -C build

RUN cp -rp /SoftEtherVPN/build/vpnserver/vpnserver /usr/local/bin/ && cp -rp /SoftEtherVPN/build/vpncmd/vpncmd /usr/local/bin/ && cp -rp /SoftEtherVPN/build/vpncmd/hamcore.se2 /usr/local/bin/

ENTRYPOINT ["vpnserver", "start"]
