FROM docker.io/library/ubuntu:20.04 AS fizz.buildroot

# System dependenices, to which fizz dynamically links to
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libssl-dev libsodium-dev libboost-all-dev cmake ninja-build libgoogle-glog-dev libdouble-conversion-dev \
        git libgflags-dev zlib1g-dev libunwind-dev libevent-dev liblz4-dev libsnappy-dev binutils-dev \
        autoconf libelf-dev libdwarf-dev libfmt-dev ccache libjemalloc-dev \
        libzstd-dev g++

ADD ./fizz-build.sh /usr/local/bin/fizz-build

FROM docker.io/library/ubuntu:20.04 AS fizz.runtime
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libboost-context1.71.0 \
        libc6 \
        libdouble-conversion3 \
        libevent-2.1-7 \
        libgcc-s1 \
        libgflags2.2 \
        libgoogle-glog0v5 \
        liblzma5 \
        libsodium23 \
        libssl1.1 \
        libstdc++6 \
        libunwind8 \
        zlib1g \
        net-tools tcpdump ethtool iproute2 python3 bash && \
        rm -rf /var/lib/apt/lists/*

COPY run_endpoint.sh ech_key_converter.py /
