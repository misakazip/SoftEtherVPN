FROM debian:stable-slim

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get -y install cmake gcc g++ make pkgconf libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create $HOME_DIR
ARG HOME_DIR='/root'
RUN mkdir -p $HOME_DIR
ENV HOME $HOME_DIR

COPY * $HOME_DIR

ENV CMAKE_FLAGS="-DSE_PIDDIR=/run/softether -DSE_LOGDIR=/var/log/softether -DSE_DBDIR=/var/lib/softether"
RUN cd $HOME_DIR && bash ./configure && make -C build

RUN cp -rp bin/vpnserver/vpnserver /usr/local/bin/ && cp -rp bin/vpncmd/vpncmd /usr/local/bin/ && cp -rp bin/vpncmd/hamcore.se2 /usr/local/bin/

ENTRYPOINT ["vpnserver", "start"]
