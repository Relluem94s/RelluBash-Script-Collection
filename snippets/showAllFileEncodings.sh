#!/bin/bash

find .  -name "*" -type f -not -path "./target/*" -not -path "./.git/*" | xargs file --mime-encoding | cut -d ':' -f2 | sed "s/ //g" | sort | uniq -c
