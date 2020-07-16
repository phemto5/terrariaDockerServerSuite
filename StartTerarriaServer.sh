#!/bin/bash
export GAME=terraria
export STORAGE=/mnt/data/terraria
export IMAGE=ryshe/terraria:latest
gameTypes=(Fresh Classic Expert Master Journey Arcadia)
export TPORT=7776;
export HPORT=7878;
clear
for type in ${gameTypes[@]}
do
	docker kill ${GAME}_$type
done
docker ps | grep ${GAME}
docker pull ${IMAGE}
docker container prune -f
for index in ${!gameTypes[@]}
do 
	tport=$((${TPORT}+$index))
	hport=$((${HPORT}+$index))
	dhost=${gameTypes[$index]}
	echo Game Port $tport
	echo Game Name $dhost
	echo Game SitePort $hport
	docker run -d \
		-p $hport:7878 \
		-p $tport:7777 \
		-v ${STORAGE}/world:/world \
		-v ${STORAGE}/config:/config \
		--name "${GAME}_$dhost" \
		--hostname t$dhost \
		--restart unless-stopped \
		-d ${IMAGE} \
		-config /config/$dhost.config
done 
docker ps | grep ${GAME}
