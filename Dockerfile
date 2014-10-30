# Dockerfile for an etcd powered dynamic ambassador container on CoreOS.

FROM shift/coreos-ubuntu-confd:latest

MAINTAINER Vincent Palmer <shift-gh@someone.section.me>

ENV DEBIAN_FRONTEND noninteractive
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y

RUN apt-get update -q
RUN apt-get install -qy build-essential curl git
RUN curl -s https://go.googlecode.com/files/go1.2.src.tar.gz | tar -v -C /usr/local -xz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/local/go/bin:$PATH
RUN cd /opt && git clone https://github.com/polvi/nsproxy
RUN cd /opt/nsproxy && ./build
ADD files/run.sh /run.sh
RUN chmod 0755 /run.sh
ENTRYPOINT ["/run.sh"]
