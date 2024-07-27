FROM ubuntu:24.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update  -y
RUN apt-get install -y python3

# create workspace
RUN mkdir -p /root/workspace
WORKDIR /root/workspace
# Keep the container running
CMD ["tail", "-f", "/dev/null"]