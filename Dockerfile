FROM ubuntu:22.04

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG PROTO_HOME=/runtime/proto
ARG PY_PACKAGE_DIR=/runtime/python/packages
ENV PROTO_HOME=$PROTO_HOME

# Make required directories
RUN mkdir -p /data/db

# Basic setup and core packages
RUN apt update -y && apt upgrade -y
RUN apt install -y bash curl unzip supervisor qemu-user-static
RUN apt install -y git gzip xz-utils

# Install MongoDB dependencies
RUN apt install -y libcurl4 libgssapi-krb5-2 libldap-2.5-0 libwrap0 libsasl2-2 libsasl2-modules libsasl2-modules-gssapi-mit openssl liblzma5

# Install proto
RUN curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --no-profile --yes

# Hack to make Proto work with Docker for subsequent RUN commands
ENV PATH="${PROTO_HOME}/bin:${PROTO_HOME}/shims:${PY_PACKAGE_DIR}/bin:$PATH"
ENV PYTHONPATH="${PY_PACKAGE_DIR}:$PYTHONPATH:."
ENV PIP_TARGET="${PY_PACKAGE_DIR}"

WORKDIR /runtime

COPY .prototools .
RUN proto install

# Install MongoDB
RUN curl -o mongo.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.18.tgz \
  && tar -xvzf mongo.tgz \
  && mv mongodb-linux-x86_64-ubuntu2204-6.0.18/bin/mongo* /usr/local/bin \
  && rm -rf mongo*

CMD ["/bin/sh", "-c", "bash"]
