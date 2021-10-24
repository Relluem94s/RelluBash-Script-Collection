#!/bin/bash

###########################################################################################
#                                    Auto Plugin Builder                                  #
#                                      by Relluem94 2021                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
# Change 'Plugins' according your Plugins you want to compile and copy                    #
# Change 'pathToRepos' to on above your git location (/home/rellu/repos/)                 #
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
line="\e[90m======================================================";
line_small="\e[37m------------------------------------------------------";

echo -e "\e[97m";
echo -e $line_small;
echo -e "\e[37mAuto Plugin Builder \e[94mv1.3";
echo -e "\e[37mChecks for each Plugin in the Array if changes are reported by git. ";
echo -e "";
echo -e "Check here for Updates: https://github.com/Relluem94s/RelluBash-Script-Collection";

list=$(printf '%s' "$(IFS=,; printf '%s' "${Plugins[*]}")");

echo -e "\e[37mPlugins configured:\e[94m $list";
echo -e "\e[37mAuto compile via Maven";
echo -e "\e[37mRemoves old Artifact / Plugin and copies new one";
echo -e $line_small;
echo -e "";

for val in ${Plugins[@]}; do
    if [[ `git -C $pathToRepos$val/ status --porcelain` ]]; then
        echo -e $line;
        
        CMD="mvn -f $pathToRepos$val/ clean install";
          echo -e "\e[93m[MAVEN]\e[97m $CMD";
        OUTPUT=$($CMD | grep '\[INFO\] BUILD' | sed 's/^\[INFO\] //g');
        echo -e "\e[93m[MAVEN]\e[97m $OUTPUT";
        
        if [ "$OUTPUT" = "BUILD FAILURE" ]; then
            echo -e "\e[91m[DELETE]\e[97m Skipped";
            echo -e "\e[92m[COPY]\e[97m Skipped";
            continue
        fi
        
        CMD="rm -f $pathToServer${val,,}-*.jar";
          echo -e "\e[91m[DELETE]\e[97m $CMD";
        $CMD;
        
        CMD="cp $pathToRepos$val/target/${val,,}-*.jar $pathToServer";
          echo -e "\e[92m[COPY]\e[97m $CMD";
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
