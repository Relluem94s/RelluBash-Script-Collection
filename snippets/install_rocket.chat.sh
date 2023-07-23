#!/bin/bash

docker run --name db -d mongo:4.0 --smallfiles --replSet rs0 --oplogSize 128
docker exec -ti db mongo --eval "printjson(rs.initiate())"
docker run --name rocketchat -p 3000:3000 --link db --env ROOT_URL=http://chat.relluem94.de --env MONGO_OPLOG_URL=mongodb://db:27017/local -d rocket.chat
