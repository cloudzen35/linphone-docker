---
title: install VM Free PBX - Asterisk
subtitle: FreePBX 14 - CentOS
author: --
date: 2019-08-31
---


Get Distro
==========


Download
--------

* [FreePBX Distro Download Links](https://www.freepbx.org/downloads/)



VM DEfine
=========


Virtualbox
----------

* enable PAE
* enable EFI
* enable Audio IN

* enable COM1 (Host Pipe)

* enable 3d Accel
* enable USB3



VM Install
==========


Options
-------

* install iso with defaults




VM Setup
========


OS Update
---------


```bash

yum check-update
yum update
yum upgrade

sync; sync: sync; telinit 6


```

Pre-Install
-----------


```bash

yum install git etckeeper


git config --global user.name  root
git config --global user.email root@localhost


etckeeper init


mkdir -p /etc/setup/doc

touch /etc/setup/doc/info.md

echo "---" >> /etc/setup/doc/info.md
echo "title: $(hostname) -- install notes" >> /etc/setup/doc/info.md
echo "subtitle: $(lsb_release -ds)" >> /etc/setup/doc/info.md
echo "date: $(date)" >> /etc/setup/doc/info.md
echo "---" >> /etc/setup/doc/info.md
echo "" >> /etc/setup/doc/info.md
echo "INSTALL NOTES" >> /etc/setup/doc/info.md
echo "=============" >> /etc/setup/doc/info.md
echo "OS Setup" >> /etc/setup/doc/info.md
echo "--------" >> /etc/setup/doc/info.md
echo "" >> /etc/setup/doc/info.md
echo "* $(date): pre-install" >> /etc/setup/doc/info.md

cat /etc/setup/doc/info.md

etckeeper commit "^setup(pre-install)"

(cd /etc; git log)



```


Access
======


Admin
-----

```bash

### 
### groupadd -g 380 wheel
### 
### echo "%wheel ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/whu
### 
### chown root:root /etc/sudoers.d/whu
### chmod 440 /etc/sudoers.d/whu
### 
### U=cloudzen
### usermod -a -G wheel $U
### 
### 
### sudo -u $U sudo -u root id -a


groupadd staff
useradd -m -g staff -G asterisk,wheel,users,adm,video,audio,tape,tcpdump,wireshark,screen cloudzen

passwd cloudzen

su - cloudzen
ssh-keygen -b 4096

ssh-copy-id cloudzen@localhost

cat ~/.ssh/authorized_keys

# cat >> ~/.ssh/authorized_keys

exit

cat /home/cloudzen/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

su - cloudzen ssh root@localhost bash -c "id; whoami; pwd"




```


Profile
-----

```bash

su - cloudzen

# cat ~/.bash_aliases
cat >> ~/.bash_aliases <<!EOF

alias ll='ls -l'
alias gst='git status'

alias tsu='tmux attach || tmux'

!EOF

. ~/.bash_aliases


alias tsu


exit

# skel

ls -la                          /etc/skel/.bash_aliases
cp /home/cloudzen/.bash_aliases /etc/skel/.bash_aliases
ls -la                          /etc/skel/.bash_aliases
cat                             /etc/skel/.bash_aliases


```




Core System
===========


Base (nox)
----------

```bash

Y=-y



##
# ---( SHELL )--------------------------------------------
#

yum install $Y mc zsh mosh

# cp -pv /usr/lib/mc/mc.*sh /etc/profile.d

yum install $Y screen tmux
yum install $Y tig
yum install $Y vim


##
# ---( PERF )--------------------------------------------
#

yum install $Y htop ncdu


##
# ---( TERM )--------------------------------------------
#

yum install $Y minicom

##
# ---( NET )--------------------------------------------
#

yum install $Y ncftp

yum install $Y iptraf
yum install $Y tcpdump
yum install $Y wireshark
yum install $Y wireshark-gnome



##
# ---( UTIL )--------------------------------------------
#

yum install $Y ack
(cd /etc/asterisk/; ack sip)

# yum install $Y ipcalc ipv6calc


```





Serial
======


Terminal
--------

* [CentOS / RHEL 7 : How to configure serial getty with systemd](https://www.thegeekdiary.com/centos-rhel-7-how-to-configure-serial-getty-with-systemd/)

```bash

##
# ---( UNIT )--------------------------------------------
#



ls -l /lib/systemd/system/serial-getty@.service
cp /usr/lib/systemd/system/serial-getty@.service /etc/systemd/system/serial-getty@ttyS0.service
cat /etc/systemd/system/serial-getty@ttyS0.service


# cat > /etc/systemd/system/serial-getty@ttyS0.service
cat <<EOF
[Service]
ExecStart=-/sbin/agetty --keep-baud 115200,38400,9600 %I $TERM
Type=idle

EOF

# ln -s /etc/systemd/system/serial-getty@ttyS0.service /etc/systemd/system/getty.target.wants/


##
# ---( SVC )--------------------------------------------
#


systemctl daemon-reload
systemctl start serial-getty@ttyS0.service
systemctl status serial-getty@ttyS0.service
systemctl enable serial-getty@ttyS0.service


minicom -D /dev/ttyS0

##
# from host:
# 
# VM - serial:
#  - enable COM1
#   - as (optional) 'named-pipe' file: '/tmp/vbox-px0-S0'
#

minicom -D /tmp/vbox-px0-S0



```


Console
-------

* [How to Enable Serial Console Output in CentOS](http://chrisreinking.com/how-to-enable-serial-console-output-in-centos/)

```bash


### vim /etc/sysconfig/grub
### 
### # add console=ttyS0 to the end of GRUB_CMDLINE_LINUX="rhgb quiet console=ttyS0"
### 
### stty -F /dev/ttyS0 speed 9600
### grub2-mkconfig -o /boot/grub2/grub.cfg
### 
### 


```









PBX Config
==========

* [Configuring Your PBX](https://wiki.freepbx.org/display/FPG/Configuring+Your+PBX)

Module Upgrade
--------------

* [fwconsole commands (13+)](https://wiki.freepbx.org/pages/viewpage.action?pageId=37912685)



```bash


# module upgrade

fwconsole ma showupgrades

fwconsole ma upgradeall

fwconsole restart

```

