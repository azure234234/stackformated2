#!/bin/bash

##KAFKA##
ip1=$1  
ip2=$2 
ip3=$3 
id1=$4
id2=$5
id3=$6

sudo yum -y update

#Renaming the server.properties file in-case if it already exists
#mv /opt/kafka/config/server.properties /opt/kafka/config/bkp_server.properties

#cd /home/
#sudo wget http://apache.org/dist/kafka/0.10.2.1/kafka_2.11-0.10.2.1.tgz
#sudo tar xvfz kafka_2.11-0.10.2.1.tgz
#sudo cp -R kafka_2.11-0.10.2.1 /opt/kafka_2.11-0.10.2.1
 
sudo useradd kafka
sudo chown -R kafka. /opt/kafka_2.11-0.10.2.1
sudo ln -s /opt/kafka_2.11-0.10.2.1 /opt/kafka
sudo chown -h kafka. /opt/kafka

sudo mkdir /var/kafka-logs
sudo chown -R kafka. /var/kafka-logs

#Privide the ip of all the nodes in the cluster
#zookeeper.connect=ehatlin1kafka01.innovate.lan:2181,ehatlin1kafka02.innovate.lan:2181,ehatlin1kafka03.innovate.lan:2181
sudo sed -i 's/zookeeper.connect=.*/zookeeper.connect='$id1':2181,'$id2':2181,'$id3':2181/' /opt/kafka/config/server.properties

##make sure to keep the broker id different for all the kafka nodes in the cluster.
if [ $(hostname -I) = $ip1 ]; then
sudo sed -i 's/#advertised.listeners=PLAINTEXT.*/host.name=0.0.0.0\nadvertised.host.name='$id1'/' /opt/kafka/config/server.properties
sudo sed -i 's/broker.id=0*/broker.id=1/' /opt/kafka/config/server.properties

fi

if [ $(hostname -I) = $ip2 ]; then
sudo sed -i 's/#advertised.listeners=PLAINTEXT.*/host.name=0.0.0.0\nadvertised.host.name='$id2'/' /opt/kafka/config/server.properties
sudo sed -i 's/broker.id=0*/broker.id=2/' /opt/kafka/config/server.properties

fi

if [ $(hostname -I) = $ip3 ]; then
sudo sed -i 's/#advertised.listeners=PLAINTEXT.*/host.name=0.0.0.0\nadvertised.host.name='$id3'/' /opt/kafka/config/server.properties
sudo sed -i 's/broker.id=0*/broker.id=3/' /opt/kafka/config/server.properties

fi


sudo sed -i 's#log.dirs=/tmp/kafka-logs*#log.dirs=/var/kafka-logs#' /opt/kafka/config/server.properties


sudo -s <<EOF

mv /etc/systemd/system/kafka.service /etc/systemd/system/bkp_kafka.service
cat <<EOT >> /etc/systemd/system/kafka.service

###
[Unit]
Description=Apache Kafka server (broker)
Documentation=http://kafka.apache.org/documentation.html
Requires=network.target remote-fs.target 
After=network.target remote-fs.target zookeeper.service

[Service]
Type=simple
User=kafka
Group=kafka
Environment=JAVA_HOME=/etc/alternatives/jre
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh

[Install]
WantedBy=multi-user.target

EOT
EOF
###


sudo systemctl daemon-reload
sudo systemctl enable kafka.service

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=9092/tcp
sudo firewall-cmd --permanent --add-port=2181/tcp
sudo firewall-cmd --reload

sudo systemctl start kafka.service
sudo systemctl status kafka.service
sudo systemctl stop kafka.service
sudo systemctl start kafka.service


