---
title: install VM SIP phone client
subtitle: ubuntu 19.04 (esktop) + docker + libphone
author: --
date: 2019-08-26
---


Get Distro
==========


Download
--------

* [Download Ubuntu Server](https://ubuntu.com/download/desktop)



VM DEfine
=========


Virtualbox
----------

* enable PAE
* enable EFI
* enable Audio IN

* enable 3d Accel
* enable USB3
* enable COM1



VM Install
==========


Options
-------

* DO NOT use LVM

* install docker
* install microk8s

* install postgres
* install google-cloud-cli


GRUB
----


* ['ESC' To Boot into recovery mode](https://wiki.ubuntu.com/RecoveryMode)


```bash

vi /etc/default/grub

# GRUB_TIMEOUT=3

update-grub


```



VM Setup
========


OS Update
---------


```bash

apt update
apt upgrade

sync; sync: sync; telinit 6


```

Pre-Install
-----------


```bash

apt install git etckeeper


git config --global user.name  root
git config --global user.email root@localhost


# etckeeper init


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


groupadd -g 380 wheel

echo "%wheel ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/whu

chown root:root /etc/sudoers.d/whu
chmod 440 /etc/sudoers.d/whu

U=cloudzen
usermod -a -G wheel $U


sudo -u $U sudo -u root id -a


```


Profile
-----

```bash


# cat ~/.bash_aliases
cat >> ~/.bash_aliases <<!EOF

alias ll='ls -l'
alias gst='git status'

alias tsu='tmux attach || tmux'

!EOF

. ~/.bash_aliases


alias tsu

# skel

ls -la                  /etc/skel/.bash_aliases
sudo cp ~/.bash_aliases /etc/skel/.bash_aliases
cat                     /etc/skel/.bash_aliases


```




Core System
===========


Base (nox)
----------

```bash

Y=-y


##
# ---( INSTALL )--------------------------------------------
#

apt install $Y gdebi
apt install $Y synaptic


##
# ---( BUILD )--------------------------------------------
#

apt install $Y build-essential

apt install $Y gfortran
apt install $Y dh-autoreconf pkgconf


apt install $Y default-jdk 
apt install $Y maven


##
# ---( ANSIBLE )--------------------------------------------
#

apt install $Y cowsay sshpass fonts-roboto filters cowsay-off

apt install $Y ansible ansible-doc ansible-lint

ansible --version


##
# ---( SHELL )--------------------------------------------
#

apt install $Y mc zsh mosh

cp -pv /usr/lib/mc/mc.*sh /etc/profile.d

apt install $Y screen tmux byobu


##
# ---( PERF )--------------------------------------------
#

apt install $Y htop ncdu
apt install $Y iptraf

##
# ---( PRINT )--------------------------------------------
#

apt install $Y cups-pdf

##
# ---( NET )--------------------------------------------
#

apt install $Y ncftp

##
# ---( UTIL )--------------------------------------------
#

apt install $Y silversearcher-ag
apt install $Y ipcalc ipv6calc



```


Docker (CE)
-----------

```bash

Y=-y


##
# ---( REMOVE )--------------------------------------------
#

snal list
snap remove docker

apt remove docker docker-engine docker.io containerd runc

##
# ---( REPO )--------------------------------------------
#

apt update

apt install $Y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"


##
# ---( INSTALL )--------------------------------------------
#

apt update


apt search docker

apt install $Y docker-ce docker-ce-cli containerd.io


# docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


##
# ---( CHECK )--------------------------------------------
#

systemctl status docker

docker ps --all
docker-compose help

docker run hello-world

##
# ---( CONFIG )--------------------------------------------
#

groupadd docker

U=cloudzen
usermod -a -G docker $U

sudo -i -u $U bash -c "whoami; docker ps --all"


```




Desktop Environment
===================


XFCE (xubuntu)
--------------

```bash

apt search  xubuntu

apt install xubuntu-desktop
apt install plymouth-theme-xubuntu-text

apt install xubuntu-default-settings
apt install xubuntu-artwork
apt install xubuntu-wallpapers
apt install xubuntu-community-wallpapers
apt install xubuntu-restricted-addons


```




LXQT
----


```bash

apt search  lxqt
apt install lxqt


```




QT
--


```bash

Y='-y'

# apt search  qt4

apt install $Y qt4-qtconfig
apt install $Y libqtcore4 libqtdbus4 libqtgui4 libqtwebkit4
  


```



Openbox
-------



```bash

Y='-y'

# apt search  openbox

apt install $Y openbox obconf openbox-menu tint2  openbox-gnome-session
apt install $Y stalonetray conky-all rox-filer
## apt install $Y roxterm


```

i3,twm
------



```bash

Y='-y'

# apt search  i3
apt install $Y dwm suckless-tools stterm surf
apt install $Y i3
apt install $Y libevent-perl libio-async-perl libpoe-perl libtask-weaken-perl 
# apt install $Y libcurses-perl libpoe-loop-event-perl libpoe-loop-tk-perl libsocket-getaddrinfo-perl libterm-readkey-perl

# apt search  twm

apt install $Y twm




```



XWindow
========

xclients
--------

* [Mosh (mobile shell)](https://mosh.org/)



```bash

Y='-y'

apt install $Y xbase-clients xclip
apt install $Y rxvt-unicode

apt install $Y xfonts-75dpi xfonts-100dpi
apt install $Y xfonts-terminus xfonts-terminus-oblique
apt install $Y fonts-noto

# apt install $Y xfonts-75dpi xfonts-100dpi xfonts-terminus fvwm-themes wm-icons nautilus imagemagick-doc autotrace cups-bsd | lpr | lprng enscript ffmpeg gimp gnuplot grads
# apt install $Y hp2xx html2ps libwmf-bin povray radiance sane-utils transfig ufraw-batch inkscape sidplayfp sndiod libwmf0.2-7-gtk mpd



```

xservers
--------

```bash

Y='-y'

# apt search  xserver

apt install $Y xserver-xephyr
apt install $Y xserver-xspice


```










APPS
====


System
--------


```bash

Y='-y'

etckeeper commit 'apps.pre'

# system

apt install $Y terminator
apt install $Y meld

# editor

apt install $Y gedit gedit-plugins gedit-latex-plugin


# internet

apt install $Y chromium-browser
apt install $Y filezilla
apt install $Y putty


# emacs 


# apt search emacs
# Y=''

Y='-y'

apt install $Y \
    emacs \
    emacs-el \
    emacs-goodies-el \
    colordiff \
    elpa-helm \
    elpa-magit \
    elpa-markdown-mode \
    gnuserv \
    gnuplot-mode \
    org-mode \
    org-mode-doc \
    python-mode \
    silversearcher-ag-el \
    twittering-mode \
    w3m-el \
    w3m \
    wl \
    yaml-mode

## apt install $Y \
##     auctex \
##     c-sig \
##     chktex \
##     colordiff \
##     dictem \
##     dictionary-el \
##     dmtcp \
##     ecb \
##     edb \
##     eldav \
##     elpa-company \
##     elpa-helm \
##     elpa-magit \
##     elpa-markdown-mode \
##     elpa-projectile \
##     elscreen \
##     elserv \
##     emacs-calfw \
##     emacs-goodies-el \
##     emacs-intl-fonts \
##     emacs-jabber \
##     evernote-mode \
##     gnuserv \
##     gnuplot-mode \
##     mmm-mode \
##     org-mode \
##     org-mode-doc \
##     planner-el \
##     prolog-el \
##     python-mode \
##     refdb-clients \
##     refdb-doc \
##     riece \
##     search-ccsb \
##     search-citeseer \
##     silversearcher-ag-el \
##     tweak \
##     twittering-mode \
##     w3m-el \
##     w3m \
##     wl \
##     x-pgp-sig-el \
##     xcite \
##     yaml-mode



## # file browser
## 
## # apt install $Y dolphin dolphin-plugins 
## 
## 
## # develop
## 
## apt install $Y git-cola
## 
## apt install $Y \
##     geany \
##     geany-plugin-addons \
##     geany-plugin-codenav \
##     geany-plugin-commander \
##     geany-plugin-ctags \
##     geany-plugin-git-changebar \
##     geany-plugin-gproject \
##     geany-plugin-insertnum \
##     geany-plugin-latex \
##     geany-plugin-lineoperations \
##     geany-plugin-lipsum \
##     geany-plugin-lua \
##     geany-plugin-macro \
##     geany-plugin-markdown \
##     geany-plugin-miniscript \
##     geany-plugin-multiterm \
##     geany-plugin-overview \
##     geany-plugin-prettyprinter \
##     geany-plugin-projectorganizer \
##     geany-plugin-sendmail \
##     geany-plugin-shiftcolumn \
##     geany-plugin-spellcheck \
##     geany-plugin-tableconvert \
##     geany-plugin-treebrowser \
##     geany-plugin-vc \
##     geany-plugin-webhelper \
##     geany-plugin-xmlsnippets 


###

etckeeper commit 'apps.post'


```




REMOTE
======


VNC
---


```bash

apt install vnc4server
apt install x2vnc

# apt install xvnc4viewer tightvncserver xtightvncviewer

# unconfigured

```

RDP
---


```bash

## apt install xrdp
## 
## # apt install guacamole xrdp-pulseaudio-installer
## 
## 
## # running on default ports ...
## 
## systemctl disable xrdp
## systemctl disable xrdp-sesman

```


NX
---


```bash

apt search  x2go

apt install $Y x2goserver
apt install $Y x2goclient

```


NOMACHINE
---------


```bash


## mkdir -p ~/Downloads
## cd       ~/Downloads
## 
## wget https://download.nomachine.com/download/6.5/Linux/nomachine_6.5.6_9_amd64.deb
## 
## gdebi nomachine_6.5.6_9_amd64.deb 



```




TELEPHONY
=========


Phone
-----

### linphone - soft phone (SIP)

#### install


```bash

apt search  linphone
apt install linphone

apt install siproxd




```


#### logs

```


###


root@arkab:~# apt install linphone

Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libantlr3c-3.4-0 libbctoolbox1 libbelcard1 libbellesip0 libbelr1 libbzrtp0 libglew2.1 liblinphone9 libmediastreamer-base10 libmediastreamer-voip10 libortp13 libturbojpeg
  linphone-common linphone-nogtk
Suggested packages:
  glew-utils
The following NEW packages will be installed:
  libantlr3c-3.4-0 libbctoolbox1 libbelcard1 libbellesip0 libbelr1 libbzrtp0 libglew2.1 liblinphone9 libmediastreamer-base10 libmediastreamer-voip10 libortp13 libturbojpeg
  linphone linphone-common linphone-nogtk
0 upgraded, 15 newly installed, 0 to remove and 0 not upgraded.
Need to get 11.9 MB of archives.
After this operation, 24.3 MB of additional disk space will be used.


```



AZ Tools Install
================




AZ CLI
------

### refs

* [Install Azure CLI with apt](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest)


### install



```bash

sudo -i


curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash


which az

az --version


```



AZ COPY
------

### refs

* [Get started with AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy)
* [AzCopy v10](https://github.com/Azure/azure-storage-azcopy)


### install



```bash

sudo -i

mkdir -p ~/Downloads
cd       ~/Downloads

#curl -O -J -L https://aka.ms/downloadazcopy-v10-linux

wget --user-agent=Mozilla --content-disposition -E -c https://aka.ms/downloadazcopy-v10-linux

ls -l

cd

mkdir -p /opt/local/az/azcopy
cd       /opt/local/az/azcopy

tar xvzf ~/Downloads/azcopy_linux_amd64*.tar.gz

ls -lR

chmod -R o-w ./azcopy_linux_amd64*

ls -lR

ln -s azcopy_linux_amd64* current

ln -s /opt/local/az/azcopy/current/azcopy /usr/local/bin/azcopy


which azcopy

azcopy --version

azcopy -h
azcopy list -h


```




.NET Core 2.0
-------------

* [Install .NET Core 2.0 Runtime on Linux Ubuntu 18.04 x64](https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/runtime-2.0.8)


### Microsoft PPA registry


```bash

wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get install apt-transport-https
sudo apt-get update


```



### .Net Runtime Install


```bash


apt search  dotnet
apt install dotnet-runtime-2.2
apt install dotnet-sdk-2.2

#apt install dotnet-runtime-2.0.8
#apt install dotnet-hosting-2.0.8


dotnet --info

```


