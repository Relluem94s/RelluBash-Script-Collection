# .bashrc

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

force_color_prompt=yes

# User specific environment
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    PATH="$HOME/bin:$PATH"
fi
if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
    PATH="$PATH:/usr/local/go/bin"
fi

export GOPATH="$HOME/go"
if [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
    PATH="$GOPATH/bin:$PATH"
fi

export PATH
export LIBVA_DRIVER_NAME=iHD

function parse_git_branch {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
} 



export PS1="\[$(tput bold)\]\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;242m\]>>\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;39m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\] \[\033[35m\]\$(parse_git_branch) \[\033[38;5;242m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# User specific aliases and functions


# Load Angular CLI autocompletion.
source <(ng completion script)
