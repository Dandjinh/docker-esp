FROM ubuntu:bionic

RUN apt-get update

# set timezone to Shanghai
RUN apt-get install -y tzdata
RUN echo "Asia/Shanghai" > /etc/timezone
RUN rm -f /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# setup ssh
RUN apt-get install -y openssh-server
RUN mkdir -p /run/sshd
RUN echo "root:123456" | chpasswd
RUN echo "PermitRootLogin Yes" >> /etc/ssh/sshd_config
EXPOSE 22

# setup esp-idf
RUN apt-get install -y git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

RUN mkdir -p /opt/esp
WORKDIR /opt/esp
RUN git clone --recursive https://github.com/espressif/esp-idf.git

WORKDIR /opt/esp/esp-idf
ENV IDF_TOOLS_PATH /opt/esp/.espressif
RUN ./install.sh

RUN alias get-idf=". /opt/esp/esp-idf/export.sh"

CMD ["/usr/sbin/sshd", "-D"]
