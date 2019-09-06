---
title: Configure PBX Extensions
subtitle: (direct) SoftPhone Connection
author: --
date: 2019-09-02
---



REFERENCES
==========


Tutorial
--------

* [FreePBX installation and basic configuration](http://www.bujarra.com/instalacion-de-freepbx-configuracion-basica/?lang=en)



Configure Extension
===================


Web Config
----------

* [Add PJSIP Extension](http://px0/admin/config.php?display=extensions)


Configure Phone
===============


Local Accounts
--------------

```

##
# @runas: root

groupadd voip


add_client() {

U=$1
N=$2
M=$3

useradd -m -g voip -G users,video,audio -c "$M" -u $N $U

R=/root/.rup
F=$(hostname)-$(date +%s); 

mkdir -p $R; chmod 700 $R; echo "$U:$(openssl rand -base64 32 | tee -a $R/$U-$F.rup)" | chpasswd

cat $R/$U-$F.rup | sudo -i -u $U sh -c "mkdir -p ~/.rup; chmod 700 ~/.rup; cat > ~/.rup/$U-$F.rup; chmod 400 ~/.rup/$U-$F.rup; ls -lda ~/.rup; ls -l ~/.rup; cat ~/.rup/$U-$F.rup"


}


add_client t6101 6101 t6101@$(hostname)
add_client t6102 6102 t6102@$(hostname)



##
# @runas: user

sudo -i -u t6101
sudo -i -u t6102


whoami; id; pwd
NOROOT=1; [ "$(id -u)" = "0" ] && exit 1

ssh_setup() {

#---( ssh )-----
echo -n 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -P '' -t rsa -b 2048
touch     ~/.ssh/config
chmod 600 ~/.ssh/config
echo "ServerAliveInterval = 10" >> ~/.ssh/config
touch     ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh localhost pwd
# :>  ~/.ssh/authorized_keys


}

ssh_setup

exit

##
# @runas: root


cat /home/cloudzen/.ssh/id_rsa.pub >> /home/t6101/.ssh/authorized_keys
cat /home/cloudzen/.ssh/id_rsa.pub >> /home/t6102/.ssh/authorized_keys

sudo -i -u cloudzen ssh t6101@localhost whoami
sudo -i -u cloudzen ssh t6102@localhost whoami


##
# @runas: cloudzen

xterm &

ssh -X t6101@localhost xterm -e linphone &
ssh -X t6102@localhost xterm -e linphone &








```

