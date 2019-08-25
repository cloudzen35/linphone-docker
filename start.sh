#!/bin/bash

set -x

xhost +

XSOCK=/tmp/.X11-unix/X0

docker run -t -i \
  --name ${1:-'phone0'} \
  -v $XSOCK:$XSOCK \
  -v /dev/snd:/dev/snd \
  -v `pwd`/hosts:/etc/hosts \
  --privileged \
  cloudzen35/linphone

# XSOCK=/tmp/.X11-unix/X0
# docker run -t -i \
#   -v $XSOCK:$XSOCK \
#   -v /dev/snd:/dev/snd \
#   -v `pwd`/hosts:/etc/hosts \
#   --lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' \
#   --privileged \
#   cloudzen35/linphone
