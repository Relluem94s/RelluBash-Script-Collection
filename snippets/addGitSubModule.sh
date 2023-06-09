#!/bin/bash

name="RelluBash-Script-Collection";
url="https://github.com/Relluem94s/$name";
file="addGitSubModule.sh";
pathToFile="snippets/";

git submodule add $url
ln -s $name/$pathToFile$file
git add .gitmodules <linked_file>
git commit -m "add a symbolic link to <linked_file> with the respective submodule"
