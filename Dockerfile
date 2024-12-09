FROM ubuntu:22.04

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

# Basic setup and core packages
RUN apt update -y && apt upgrade -y
RUN apt install -y bash curl unzip supervisor qemu-user-static

# Install MongoDB dependencies
RUN apt install -y libcurl4 libgssapi-krb5-2 libldap-2.5-0 libwrap0 libsasl2-2 libsasl2-modules libsasl2-modules-gssapi-mit openssl liblzma5

# Default data directory for MongoDB.
RUN mkdir -p /data/db

# Install Mise as a Runtime Version Manager
RUN curl https://mise.jdx.dev/mise-latest-${TARGETOS}-${TARGETARCH} > /usr/local/bin/mise \
  && chmod +x /usr/local/bin/mise \
  && echo 'eval "$(mise activate bash --shims)"' >> ~/.bash_profile \
  && echo 'eval "$(mise activate bash --shims)"' >> ~/.bashrc

# Hack to make Mise work with Docker for subsequent RUN commands
ENV PATH="/root/.local/share/mise/shims:$PATH"

WORKDIR /runtime

RUN mise use -g node@20.18.1
RUN mise use -g python@3.10.15

# Install MongoDB
RUN curl -o mongo.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.18.tgz \
  && tar -xvzf mongo.tgz \
  && mv mongodb-linux-x86_64-ubuntu2204-6.0.18/bin/mongo* /usr/local/bin \
  && rm -rf mongo*

# RUN curl -o mongo.tgz https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2204-6.0.18.tgz \
#   && tar -xvzf mongo.tgz \
#   && mv mongodb-linux-aarch64-ubuntu2204-6.0.18/bin/mongo* /usr/local/bin \
#   && rm -rf mongo*

CMD ["/bin/sh", "-c", "bash"]
