FROM ubuntu:24.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    ca-certificates \
    curl \
    apt-utils \
    build-essential \
    python3 \
    python3-venv \
    python3-setuptools \
    python3-certifi \
    python3-distro \
    python3-pip \
    git

# create workspace
RUN mkdir -p /root/workspace
WORKDIR /root/workspace
# Keep the container running
CMD ["tail", "-f", "/dev/null"]