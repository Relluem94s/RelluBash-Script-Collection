#!/bin/bash

if [ $# -lt 3 ]; then
        echo "Usage: $0 folder groupId artifactId"
        exit
fi

folder=$1
groupId=$2
artifactId=$3
shift 3

cd $folder
mvn archetype:generate -DgroupId=$groupId -DartifactId=$artifactId -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false

