# timing-docker

## Purpose

TL;DR: If you can't compile or synthesize bel_projects (because your distribution has dropped Python2 support or uses a recent GCC version, ...) this will help you out.

## Prerequisites

- Valid Quartus license
- Quartus installation on your host (18.1 recommended)
- Docker

### Quartus License

Here comes the tricky part:

1. Use the Makefile target to copy your license into the container:

<pre>
$ make copy_license LICENSE_FILE=/home/user/path_to_your_license_file/license.dat
$ make build
</pre>

2. Give your container the right MAC address (used by your Quartus License)

<pre>
$ make create_mac MAC_ADDR=00:11:22:aa:bb:cc
$ make build
</pre>

3. Start the container and run "activate_quartus_license"

<pre>
$ make QUARTUS_DIR=/opt/quartus/ # on your host ***
$ activate_quartus_license # inside your container
</pre>

*** Expected structure in your Quartus directory:
<pre>
ls -la /opt/quartus
total 40
drwxrwxr-x. 10 root quartus 4096 Nov 23  2018 ./
drwxrwxr-x.  4 root quartus 4096 Jul  8  2019 ../
drwxrwxr-x. 12 root quartus 4096 Nov 23  2018 hld/
drwxrwxr-x.  9 root quartus 4096 Nov 23  2018 hls/
drwxr-xr-x.  3 root quartus 4096 Nov 23  2018 ip/
drwxr-xr-x.  7 root quartus 4096 Nov 23  2018 licenses/
drwxrwxr-x.  2 root quartus 4096 Nov 23  2018 logs/
drwxrwxr-x.  7 root quartus 4096 Nov 23  2018 nios2eds/
drwxrwxr-x. 16 root quartus 4096 Nov 23  2018 quartus/
drwxrwxr-x.  2 root quartus 4096 Nov 23  2018 uninstall/
</pre>

4. Test if everything works

<pre>
$ cd workspace # inside you container
$ OPTIONAL: ./start.sh # inside your container ***
$ OPTIONAL: cd bel_projects # inside your container
$ OTTIONAL: LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 make exploder5
</pre>

*** This will build etherbone and saftlib

### Docker

You need a working Docker installation. Check the official Docker docs:

- CentOS: https://docs.docker.com/engine/install/centos/
- Debian: https://docs.docker.com/engine/install/debian/
- Fedora: https://docs.docker.com/engine/install/fedora/
- Ubuntu: https://docs.docker.com/engine/install/ubuntu/

#### Important Docker Commands

<pre>
$ sudo systemctl enable docker
$ sudo systemctl status docker
$ sudo systemctl start docker
$ sudo systemctl stop docker
</pre>

## Common Problems

### How can I get my builds?

Just work inside workspace directory, this will be mounted.

### Quartus or Make Target crashes (core dumped)

Solution:

<pre>
$ LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 quartus
$ LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 make exploder5
</pre>
