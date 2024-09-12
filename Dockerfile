FROM debian:stable-slim

SHELL ["/bin/bash", "-c"]

# Install essential packages
RUN apt-get update && apt-get -y install git cmake gcc g++ make pkgconf libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone repo
RUN git clone --recursive --depth=1 https://github.com/SoftEtherVPN/SoftEtherVPN.git && cd SoftEtherVPN

# Build and install
# In arm64, sometimes errors occur while building.In my experience, if you build it again, it usually fix.
RUN cd /SoftEtherVPN && ./configure && make -j5 -C build || make -j5 -C build 
RUN cd /SoftEtherVPN && make -C install

ENTRYPOINT ["vpnserver", "start"]
