#!/bin/bash

##ElasticSearch##
ip1=$1  
ip2=$2 
ip3=$3 
id1=$4
id2=$5
id3=$6

sudo yum -y update

if [ $(hostname -I) = $ip1 ]; then
###
sudo sed -i 's/#cluster.name:.*/cluster.name: eviCoreServices/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name:.*/node.name: node-1/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host:.*/network.host: "'$id1'"/' /etc/elasticsearch/elasticsearch.yml 
sudo sed -i 's/#discovery.zen.ping.unicast.hosts:.*/discovery.zen.ping.unicast.hosts: ["'$id1'", "'$id2'", "'$id3'"] /' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.zen.minimum_master_nodes:.*/discovery.zen.minimum_master_nodes: 2/' /etc/elasticsearch/elasticsearch.yml
###
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=9200/tcp
sudo firewall-cmd --permanent --add-port=9300/tcp
sudo firewall-cmd --reload

sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service



##Install Kibana##

sudo systemctl daemon-reload
sudo systemctl enable kibana.service

##
sudo sed -i 's/#server.host:.*/server.host: "'$id1'"/' /etc/kibana/kibana.yml
sudo sed -i 's/#elasticsearch.url:.*/elasticsearch.url: "http://'$id1':9200"/' /etc/kibana/kibana.yml
##

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=5601/tcp
sudo firewall-cmd --reload	

sudo systemctl start kibana.service
sudo systemctl stop kibana.service

fi 

if [ $(hostname -I) = $ip2 ]; then

###
sudo sed -i 's/#cluster.name:.*/cluster.name: eviCoreServices/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name:.*/node.name: node-2/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host:.*/network.host: "'$id2'"/' /etc/elasticsearch/elasticsearch.yml 
sudo sed -i 's/#discovery.zen.ping.unicast.hosts:.*/discovery.zen.ping.unicast.hosts: ["'$id1'", "'$id2'", "'$id3'"] /' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.zen.minimum_master_nodes:.*/discovery.zen.minimum_master_nodes: 2/' /etc/elasticsearch/elasticsearch.yml
###

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=9200/tcp
sudo firewall-cmd --permanent --add-port=9300/tcp
sudo firewall-cmd --reload

sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service

fi

if [ $(hostname -I) = $ip3 ]; then

###
sudo sed -i 's/#cluster.name:.*/cluster.name: eviCoreServices/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name:.*/node.name: node-3/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host:.*/network.host: "'$id3'"/' /etc/elasticsearch/elasticsearch.yml 
sudo sed -i 's/#discovery.zen.ping.unicast.hosts:.*/discovery.zen.ping.unicast.hosts: ["'$id1'", "'$id2'", "'$id3'"] /' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.zen.minimum_master_nodes:.*/discovery.zen.minimum_master_nodes: 2/' /etc/elasticsearch/elasticsearch.yml
###

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=9200/tcp
sudo firewall-cmd --permanent --add-port=9300/tcp
sudo firewall-cmd --reload

sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service

fi

if [ $(hostname -I) = $ip1 ]; then

sudo systemctl start elasticsearch.service
sudo systemctl start kibana.service

fi

if [ $(hostname -I) = $ip2 ]; then

sudo systemctl start elasticsearch.service

fi

if [ $(hostname -I) = $ip3 ]; then

sudo systemctl start elasticsearch.service

fi
