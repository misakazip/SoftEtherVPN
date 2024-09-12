FROM debian:stable-slim

SHELL ["/bin/bash", "-c"]

# Install essential packages
RUN apt-get update && apt-get -y install git cmake gcc g++ make pkgconf libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone repo
RUN git clone --recursive --depth=1 https://github.com/SoftEtherVPN/SoftEtherVPN.git && cd SoftEtherVPN

# Build
RUN cd /SoftEtherVPN && ./configure && make -j5 -C build

# Copy files
RUN cp -rp /SoftEtherVPN/build/vpnserver /usr/local/bin/ && cp -rp /SoftEtherVPN/build/vpncmd /usr/local/bin/ && cp -rp /SoftEtherVPN/build/hamcore.se2 /usr/local/bin/

ENTRYPOINT ["vpnserver", "start"]
