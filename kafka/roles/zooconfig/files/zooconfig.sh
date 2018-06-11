#!/bin/bash

ip1=$1  #{1:?Please enter the ipaddress1}
ip2=$2  #{2:?Please enter the ipaddress2}
ip3=$3  #{3:?Please enter the ipaddress3}

###############

if [ $(hostname -I) = $ip1 ]; then

sudo -s <<EOF
sudo echo "1" > /var/zookeeper/myid
EOF

fi

if [ $(hostname -I) = $ip2 ]; then

sudo -s <<EOF
sudo echo "2" > /var/zookeeper/myid
EOF

fi

if [ $(hostname -I) = $ip3 ]; then

sudo -s <<EOF

sudo echo "3" > /var/zookeeper/myid

EOF

fi

sudo systemctl start zookeeper.service
sudo systemctl stop zookeeper.service
sudo systemctl reload zookeeper.service
sudo systemctl start  zookeeper.service
