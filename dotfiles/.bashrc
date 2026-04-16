# ── Toolbox .bashrc ────────────────────────────────────────────────────────────

# Prompt: user@toolbox:~/path $
PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;36m\]toolbox\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Aliases
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias grep='grep --color=auto'
alias scripts='cd /root/scripts'

# AWS convenience
alias awswho='aws sts get-caller-identity'

# Source local overrides if present (mounted at runtime)
[[ -f /root/.bashrc_local ]] && source /root/.bashrc_local