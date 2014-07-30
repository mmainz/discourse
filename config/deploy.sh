#!/bin/bash
ssh root@146.185.165.72 "cd /var/deployment && git clone https://github.com/mmainz/discourse.git && cd discourse && git checkout $COMMIT"
ssh root@146.185.165.72 << 'ENDSSH'
cd /var/deployment/discourse
./docker-build.sh
docker rm -f discourse
docker run -d -p 80:80 -p 443:443 --name discourse --link redis:redis --link postgres:db mmainz/discourse ./docker-startup.sh
docker rmi $(docker images -q -f 'dangling=true')
rm -rf /var/deployment/discourse
ENDSSH
