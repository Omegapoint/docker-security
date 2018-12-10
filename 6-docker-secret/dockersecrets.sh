#!/bin/sh
printf "****************************************************\n"
printf "Create a single-node swarm and deploy NGINX with HTTPS configured that makes use of Docker secrets\n"
printf "****************************************************\n"
eval $(docker-machine env docker-security-1)
master_ip=$(docker-machine ip docker-security-1)
printf "Create a new swarm on docker-security-1"
printf "\n"
docker swarm init --advertise-addr $master_ip
printf "Create secrets and configuration"
printf "\n"
docker secret create site.key site.key > /dev/null
docker secret create site.crt site.crt > /dev/null
docker config create site.conf site.conf > /dev/null
printf "Create service nginx using Docker secrets and config."
printf "\n"
docker service create \
     --name nginx \
     --secret site.key \
     --secret site.crt \
	 --config source=site.conf,target=/etc/nginx/conf.d/site.conf,mode=0440 \
     --publish published=3000,target=443 \
     nginx:latest > /dev/null
docker service ls
printf "Test if nginx is up an running"
printf "\n"
docker-machine ssh docker-security-1 'curl --cacert ca.pem https://localhost:3000'