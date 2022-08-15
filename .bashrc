# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions

function parse_git_branch {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
} 

force_color_prompt=yes

export PS1="\[$(tput bold)\]\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;242m\]>>\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;39m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\] \[\033[35m\]\$(parse_git_branch) \[\033[38;5;242m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

export PATH="$PATH:/opt/netbeans/bin/"
export PATH=$PATH:"~/repos/RelluBash-Script-Collection/"
export ANDROID_SDK_ROOT=$HOME/Android/Sdk/
export ANDROID_HOME=$HOME/.android/
export PATH="$ANDROID_SDK_ROOT/tools:$PATH"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"
export PATH="$HOME/repos/chromium/depot_tools/:$PATH"
