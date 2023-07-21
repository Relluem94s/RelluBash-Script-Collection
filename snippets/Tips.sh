#!/bin/bash

###########################################################################################
#                                          Bash Tips                                      #
#                                     by Relluem94 2023                                   #
###########################################################################################
#                                                                                         #
#                                                                                         #
# This will show you some tips and tricks for bash                                        #
# Credit: https://stackoverflow.com/a/966079                                              #
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#

cat <<EOF
--------------------------------------------
              DIRECTORIES
--------------------------------------------
~-      Previous working directory
pushd tmp   Push tmp && cd tmp
popd        Pop && cd

--------------------------------------------
      GLOBBING AND OUTPUT SUBSTITUTION
--------------------------------------------
ls a[b-dx]e Globs abe, ace, ade, axe
ls a{c,bl}e Globs ace, able
\$(ls)      \`ls\` (but nestable!)

--------------------------------------------
          HISTORY MANIPULATION
--------------------------------------------
!!      Last command
!?foo       Last command containing \`foo'
^foo^bar^   Last command containing \`foo', but substitute \`bar'
!!:0        Last command word
!!:^        Last command's first argument
!\$     Last command's last argument
!!:*        Last command's arguments
!!:x-y      Arguments x to y of last command
C-s     search forwards in history
C-r     search backwards in history

--------------------------------------------
            LINE EDITING
--------------------------------------------
M-d     kill to end of word
C-w     kill to beginning of word
C-k     kill to end of line
C-u     kill to beginning of line
M-r     revert all modifications to current line
C-]     search forwards in line
M-C-]       search backwards in line
C-t     transpose characters
M-t     transpose words
M-u     uppercase word
M-l     lowercase word
M-c     capitalize word

--------------------------------------------
           COMPLETION
--------------------------------------------
M-/     complete filename
M-~     complete user name
M-@     complete host name
M-\$        complete variable name
M-!     complete command name
M-^     complete history
EOF


#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
