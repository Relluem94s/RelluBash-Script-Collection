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

parse_git_status() {
     git branch &>/dev/null || return

    local branch=$(git branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch="no-branch"

    local status=$(git status --porcelain 2>/dev/null)

    local modified=$(echo "$status" | grep -c '^.[MD]')
    local staged=$(echo "$status" | grep -c '^[MADRC]')
    local untracked=$(echo "$status" | grep -c '^??')
    local deleted=$(echo "$status" | grep -c '^.[D]')

    local reset="\x01\e[0m\x02"
    local green="\x01\e[38;5;84m\x02"
    local red="\x01\e[38;5;203m\x02"
    local yellow="\x01\e[38;5;221m\x02"
    local pink="\x01\e[38;5;212m\x02"

    local color="$green"
    [ "$modified" -gt 0 ] && color="$red"
    [ "$staged" -gt 0 ] && [ "$modified" -eq 0 ] && color="$yellow"

    local out="(${color}${branch}${reset}"
    [ "$staged" -gt 0 ] && out="${out} ${yellow}+${staged}${reset}"
    [ "$modified" -gt 0 ] && out="${out} ${red}~${modified}${reset}"
    [ "$untracked" -gt 0 ] && out="${out} ${pink}?${untracked}${reset}"
    [ "$deleted" -gt 0 ] && out="${out} ${red}-${deleted}${reset}"
    out="${out})"
    
    echo -e "$out"
} 

export PS1='\[\e[1m\]\[\e[38;5;220m\]\u\[\e[0m\] \[\e[38;5;242m\]>> \[\e[38;5;39m\]\w\[\e[0m\] $(parse_git_status) \[\e[38;5;242m\]\$\[\e[0m\] '

# User specific aliases and functions
alias reload="source ~/.bashrc" 

# Load Angular CLI autocompletion.
source <(ng completion script)
