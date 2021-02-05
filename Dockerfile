# LTS Ubuntu
FROM ubuntu:18.04

# Set ENV otherwise defconf might crash
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Variables
ARG BASHRC=/root/.bashrc

# Add i386 architecture (Quartus needs this)
RUN dpkg --add-architecture i386

# Generic stuff
RUN apt-get update
RUN apt-get install -y apt-utils

# Timing stuff
RUN apt-get install -y \
                    git \
                    python2.7 \
                    docbook-utils \
                    libglib2.0-dev \
                    autotools-dev \
                    autoconf \
                    libtool \
                    build-essential \
                    automake \
                    libreadline-dev \
                    lsb-core \
                    python-six \
                    libboost-dev \
                    libsigc++-2.0-dev \
                    xsltproc \
                    ca-certificates \
                    libc6-dev-i386 \
                    lib32z1 \
                    libfontconfig1 \
                    libglib2.0-0 \
                    libncurses5 \
                    libsm6 \
                    libssl-dev \
                    libstdc++6 \
                    libxext6 \
                    libxft2 \
                    libxrender1 \
                    libzmq3-dev \
                    locales \
                    make \
                    openjdk-8-jdk \
                    pkg-config \
                    unixodbc-dev \
                    wget \
                    xauth \
                    xvfb

# Quartus stuff
RUN apt-get install -y \
                    libc6:i386 \
                    libc6-dev-i386 \
                    liblzma-dev \
                    libncurses5:i386 \
                    libqt5xml5 \
                    libstdc++6:i386 \
                    libxft2 \
                    libxft2:i386 \
                    libxtst6:i386 \
                    lib32z1

# Network stuff
RUN apt-get install -y \
                    net-tools \
                    iproute2

# Prepare folders
RUN mkdir -p /opt/quartus
RUN mkdir -p /workspace

# Apply LM32 toolchain patch (multiple-precision floating-point computations)
RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

# Install libpng patch (Quartus needs this)
RUN mkdir /root/resources
COPY resources/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb /root/resources
RUN dpkg -x /root/resources/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb /root/resources/extract/
RUN cp -f /root/resources/extract/lib/x86_64-linux-gnu/* /lib/x86_64-linux-gnu/

# Install Quartus license
COPY resources/license.dat /root/resources/license.dat
RUN mkdir -p "/root/.altera.quartus"
RUN echo "[General 18.1]" >> /root/.altera.quartus/quartus2.ini
RUN echo "LICENSE_FILE = /root/resources/license.dat" >> /root/.altera.quartus/quartus2.ini
COPY resources/mac /root/resources/mac

# Set up locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Prepare build environment
RUN echo "" >> $BASHRC
RUN echo "export QUARTUS=/opt/quartus/quartus" >> $BASHRC
RUN echo "export QSYS_ROOTDIR=/opt/quartus/quartus/sopc_builder/bin" >> $BASHRC
RUN echo "export QUARTUS_ROOTDIR=/opt/quartus/quartus" >> $BASHRC
RUN echo "export QUARTUS_BINDIR=/opt/quartus/quartus/bin" >> $BASHRC
RUN echo "export QUARTUS_64BIT=1" >> $BASHRC
RUN echo "export PATH=$PATH:\$QUARTUS_ROOTDIR:\$QUARTUS_BINDIR:\$QSYS_ROOTDIR" >> $BASHRC
RUN echo "" >> $BASHRC
RUN echo "export LM_LICENSE_FILE=/root/resources/license.dat" >> $BASHRC
RUN echo "export ALTERAD_LICENSE_FILE=/root/resources/license.dat" >> $BASHRC
RUN echo "alias quartus_no_crash='LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 /opt/quartus/quartus/bin/quartus'" >> $BASHRC
RUN echo "" >> $BASHRC
RUN echo "alias activate_quartus_license='ip link add eth9 type dummy > /dev/null 2>&1 && ip link set eth9 address $(cat /root/resources/mac) > /dev/null 2>&1 '" >> $BASHRC
RUN echo "" >> $BASHRC
RUN echo "export LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1" >> $BASHRC
RUN echo "" >> $BASHRC
RUN echo "activate_quartus_license" >> $BASHRC
RUN echo "" >> $BASHRC

# Git initial configuration
RUN git config --global user.name "Docker Build"
RUN git config --global user.email "docker@build.local"
