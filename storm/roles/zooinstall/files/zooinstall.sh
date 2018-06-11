#!/bin/bash

ip1=$1  
ip2=$2 
ip3=$3
id1=$4
id2=$5
id3=$6 

sudo yum -y update

cd /home
sudo tar xvzf zookeeper-3.4.10.tar.gz
sudo cp -R zookeeper-3.4.10 /opt

sudo useradd zookeeper
sudo chown -R zookeeper. /opt/zookeeper-3.4.10
sudo ln -s /opt/zookeeper-3.4.10 /opt/zookeeper
sudo chown -h zookeeper. /opt/zookeeper

sudo mkdir /var/zookeeper
sudo chown -R zookeeper. /var/zookeeper

cd /opt/zookeeper/conf
#sudo cp zoo_sample.cfg zoo.cfg

sudo chown -R zookeeper. /opt/zookeeper/conf/zoo.cfg

sudo mkdir /var/lib/zookeeper
sudo chown zookeeper. /var/lib/zookeeper
#######################################
sudo -s <<EOF
mv /opt/zookeeper/conf/zoo.cfg /opt/zookeeper/conf/bkp_zoo.cfg
cat <<EOL >> /opt/zookeeper/conf/zoo.cfg

# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/var/zookeeper
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1


##Enter the Server Details Below##

server.1=$id1:2888:3888
server.2=$id2:2888:3888
server.3=$id3:2888:3888

EOL
EOF

#######################################
sudo -s <<EOF
mv /etc/systemd/system/zookeeper.service /etc/systemd/system/bkp_zookeeper.service
cat <<EOT >> /etc/systemd/system/zookeeper.service

[Unit]
Description=Apache Zookeeper server
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=forking
User=zookeeper
Group=zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start
ExecStop=/opt/zookeeper/bin/zkServer.sh stop
ExecReload=/opt/zookeeper/bin/zkServer.sh restart
WorkingDirectory=/var/lib/zookeeper

[Install]
WantedBy=multi-user.target
EOT
EOF
#######################################

#Verify services
sudo systemctl daemon-reload
sudo systemctl enable zookeeper.service


#Open Ports
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=2181/tcp
sudo firewall-cmd --permanent --add-port=2888/tcp
sudo firewall-cmd --permanent --add-port=3888/tcp
sudo firewall-cmd --reload

