FROM ubuntu:18.04


ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y --no-install-recommends \
        libgstreamer1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-bad1.0-0 \
        libgstrtspserver-1.0-0 \
        gstreamer1.0-x \
        gstreamer1.0-nice \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-ugly \
        wget \
        curl \
        ca-certificates \
        gnupg

RUN --mount=type=cache,target=/root/.cargo curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN apt install -y --no-install-recommends build-essential
RUN apt install -y --no-install-recommends pkg-config
RUN apt install -y --no-install-recommends libglib2.0-dev
RUN apt install -y --no-install-recommends libssl-dev
RUN apt install -y --no-install-recommends libgstrtspserver-1.0-0 \
                                            gstreamer1.0-rtsp \ 
                                            gstreamer1.0-plugins-bad \ 
                                            gstreamer1.0-libav \ 
                                            libgstrtspserver-1.0-dev \
                                            libgstreamer-plugins-bad1.0-dev \
                                            libges-1.0-dev 
RUN apt install -y --no-install-recommends libclang-dev #wtf

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update -y && apt install -y --no-install-recommends nodejs
RUN npm install -g yarn

RUN --mount=type=cache,target=/root/.cargo /bin/bash -c "PATH=/root/.cargo/bin/:$PATH rustup target add aarch64-unknown-linux-gnu"

# install yarn
#
# now we build the actual thing
COPY ./ ./camera
WORKDIR ./camera
RUN --mount=type=cache,target=/root/.cargo /bin/bash -c "PKG_CONFIG_ALLOW_CROSS=1 PATH=/root/.cargo/bin/:$PATH cargo build --release --target aarch64-unknown-linux-gnu"

CMD /bin/bash


