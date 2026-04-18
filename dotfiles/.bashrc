# ── Toolbox .bashrc ────────────────────────────────────────────────────────────

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ── History ────────────────────────────────────────────────────────────────────
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# ── Prompt ─────────────────────────────────────────────────────────────────────
# Shows venv name if active
venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "($(basename "$VIRTUAL_ENV")) "
    fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

PS1='$(venv_info)\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]toolbox\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# ── Color ──────────────────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ── Aliases ────────────────────────────────────────────────────────────────────
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias scripts='cd /root/scripts'

# ── AWS convenience ────────────────────────────────────────────────────────────
alias awswho='aws sts get-caller-identity'

# ── Terraform repo scaffolder ──────────────────────────────────────────────────
tfrepo() {
    if [ -z "$1" ]; then
        echo "Usage: tfrepo <repo-name>"
        return 1
    fi

    REPO_NAME=$1
    BASE_DIR=$(pwd)

    mkdir -p "$BASE_DIR/$REPO_NAME"
    cd "$BASE_DIR/$REPO_NAME" || return

    git init

    mkdir modules
    mkdir environments
    mkdir environments/dev
    mkdir environments/prod

    touch main.tf
    touch variables.tf
    touch outputs.tf
    touch providers.tf
    touch versions.tf

    echo "# $REPO_NAME" > README.md
    echo "Terraform lab environment." >> README.md

    git add .
    git commit -m "Initial commit"

    echo "Terraform repo '$REPO_NAME' created."
}

# ── Bash completion ────────────────────────────────────────────────────────────
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ── Local overrides (mounted at runtime) ──────────────────────────────────────
[[ -f /root/.bashrc_local ]] && source /root/.bashrc_local
