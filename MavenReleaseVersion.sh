#!/bin/bash


###########################################################################################
#                                    MavenReleaseVersion                                  #
#                                     by Relluem94 2023                                   #
###########################################################################################
#                                                                                         #
#                                                                                         #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                      VARIABLES TO EDIT                                  #
###########################################################################################

# None

###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
name="MavenReleaseVersion";
version="v0.2";


if [ $# -lt 2 ]; then
        echo "Usage of $name@$version: $0 pathToFolder version"
        exit
fi

folder=$1
version=$2

shift 2

cd $folder

mvn versions:set versions:commit -DnewVersion=$version

mvn javadoc:javadoc
git add docs
git commit -m "Updated docs"

git add pom.xml
git commit -m "Bumped to Version: $version"

git tag $version

git push && git push --tags

#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
