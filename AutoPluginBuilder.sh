#!/bin/bash

###########################################################################################
#                                    Auto Plugin Builder                                  #
#                                      by Relluem94 2021                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
# Change 'Plugins' according your Plugins you want to compile and copy                    #
# Change 'pathToRepos' to one above your git location (/home/rellu/repos/)                 #
# Change 'pathToServer' to your "plugins" folder                                          #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                      VARIABLES TO EDIT                                  #
###########################################################################################
declare -a Plugins=("RelluEssentials" "RelluSGA" "Capturespleef");
pathToRepos="/home/rellu/repos/";
pathToServer="/home/rellu/repos/test-server/plugins/";
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
line="\e[90m============================================================";
line_small="\e[37m------------------------------------------------------------";
prefix_maven="\e[93m[MAVEN]     ";
prefix_delete="\e[91m[DELETE]    ";
prefix_copy="\e[92m[COPY]      ";
main_color="\e[97m";
version="v1.4";

echo -e "\e[97m";
echo -e $line_small;
echo -e "\e[37mAuto Plugin Builder \e[94m$version";
echo -e $line_small;
echo -e "\e[37mChecks for each Plugin in the Array if changes are reported by git. ";
echo -e "\e[37mYou can build without changes if you append ’ignoreGit’ after the script name.";
echo -e "\e[37mExample:\e[36m ./AutoPluginBuilder.sh ignoreGit";
echo -e "";

list=$(printf '%s' "$(IFS=,; printf '%s' "${Plugins[*]}")");

echo -e "\e[37mPlugins configured:\e[94m $list";
echo -e "$prefix_maven\e[37mAuto compile via Maven";
echo -e "$prefix_delete\e[37mRemoves old Artifact / Plugin";
echo -e "$prefix_copy\e[37mCopies new Artifact / Plugin";

echo -e "";
echo -e "Check here for Updates: https://github.com/Relluem94s/RelluBash-Script-Collection";
echo -e $line_small;
echo -e "";

for val in ${Plugins[@]}; do
    if [[ `git -C $pathToRepos$val/ status --porcelain` ]] || [[ $1 = "ignoreGit" ]]; then
        echo -e $line;
        
        CMD="mvn -f $pathToRepos$val/ clean install";
          echo -e "$prefix_maven$main_color $CMD";
        OUTPUT=$($CMD | grep '\[INFO\] BUILD' | sed 's/^\[INFO\] //g');
        echo -e "$prefix_maven$main_color $OUTPUT";
        
        if [ "$OUTPUT" = "BUILD FAILURE" ]; then
            echo -e "$prefix_delete$main_color Skipped";
            echo -e "$prefix_copy$main_color Skipped";
            continue
        fi
        
        CMD="rm -f $pathToServer${val,,}-*.jar";
          echo -e "$prefix_delete$main_color $CMD";
        $CMD;
        
        CMD="cp $pathToRepos$val/target/${val,,}-*.jar $pathToServer";
          echo -e "$prefix_copy$main_color $CMD";
        $CMD;
        
        echo -e $line;
        echo -e "";
    fi
done
echo -en "\e[0m"
#
#
#
###########################################################################################
