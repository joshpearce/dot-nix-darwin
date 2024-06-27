# Borrowing from: https://github.com/bdd/.dotfiles/blob/main/dot.zshrc

# direnv
eval "$(direnv hook zsh)"

# vim: filetype=zsh

# Git Prompt
source ~/.zsh-git-prompt/zshrc.sh
setopt prompt_subst
export PROMPT='%n@%m:%~🌵🌮$(git_super_status) '

# To profile zsh startup, run:
# % ZPROF=1 zsh -ic "zprof;exit"
((ZPROF > 0)) && zmodload zsh/zprof

### zshoptions(1)
# Changing Directories
setopt auto_cd               # if not a command but a dir name, cd into it
setopt auto_pushd            # cd pushes old dir onto dir stack
setopt pushd_ignore_dups     # ...but don't allow dupes in the stack
setopt pushd_minus           # use '-' instead of '+' to refer stack location
setopt pushd_silent          # don't print dirstack when using `pushd` and `popd` directly

# Completion
setopt complete_in_word      # complete in word from both sides
setopt list_packed           # print matches in columns to occupy less lines.

# Expansion and Globbing
setopt bad_pattern           # if a pattern is badly formed, print an error
setopt nomatch               # if a pattern has no matches, print an error
setopt magic_equal_subst     # always filename expand expression after equals (e.g. foo=~bar/a[...])
setopt mark_dirs             # append a trailing '/' to dir names from globbing.

# History
setopt extended_history      # save cmd's begin timestamp and duration
setopt hist_fcntl_lock       # use fcntl(2) to lock the HISTFILE
setopt hist_ignore_all_dups  # no dupes in history
setopt hist_ignore_space     # ignore commands with leading spaces
setopt hist_reduce_blanks    # tidy up commands before saving to history
setopt share_history
bindkey '\e[A' history-search-backward # autocompletion using arrow keys (based on history)
bindkey '\e[B' history-search-forward # autocompletion using arrow keys (based on history)

# Directory colors
if whence dircolors >/dev/null; then
  eval "$(dircolors -b)"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls -F --color'
else
  alias ls='ls -F'
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
fi

# Input/Output
setopt correct               # try to correct the spelling of commands
setopt interactive_comments  # allow comments for interactive shells

# Job Control
setopt auto_continue         # send SIGCONT to stopped jobs after disown

# ZLE
setopt no_beep               # no beeping at all

### zshparam(1)
HISTSIZE=2000
SAVEHIST=2000
HISTFILE="$HOME/.zhistory"
HISTORY_IGNORE='(cd(| -| ..)|ls|pwd|bg|fg|clear|mount)'
DIRSTACKSIZE=32              # limit number of dirs kept in stack so it doesn't get unwieldy
WORDCHARS=${WORDCHARS:s,/,,} # Remove '/' from WORDCHARS so path components are treated like words.

### Aliases
# Global
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g G='| grep -F --color=auto'
alias -g L='| less -RS'
alias -g S='| sort'
alias -g WC='| wc -l'

# Command
alias h=history
alias dv='dirs -v' # need a shorter command to see the dirstack
alias utc='date -u "+%Y-%m-%dT%H:%MZ"'

# Directory
hash -d D=~/Desktop
hash -d d=~/Downloads
# OS specific directories
if [[ $OSTYPE =~ ^darwin ]]; then
  hash -d a=~/Applications
  hash -d icloud=~/Library/Mobile\ Documents/com\~apple\~CloudDocs
fi

### Key Bindings
bindkey -e # Emacs key bindings
bindkey '^G' pound-insert

### RC Extensions
# Load: ~/.config/shrc/*.zsh, ~/.config/shrc/*.sh, and ~/.zshrc.local
function { local f; for f ($@) source $f } ~/.config/shrc/*.{z,}sh(N) ~/.zshrc.local(N)

### Completion
# This section *MUST* be at the end of ~/.zshrc and no other sourced rc file
# should call `compinit` on their own.  `compinit` uses a dump file to speed up
# loading of completion files. If it detects a change in the number of the
# completion files, it will regenerate the dump file. Dump file generation slows
# down initialization time.
autoload -Uz compinit
mkdir -p ~/.cache
compinit -d ~/.cache/zcompdump

######## END COMMON DOT FILE ########################################################

# becuase of rust tab completion instructions
fpath+=~/.zfunc

# alises
alias gits='git status -bs'
alias tf="terraform"

# Mac Ports
# port() { sudo /opt/sudoport "$@"; }; 

# Brew
# brew() { sudo /opt/sudobrew "$@"; }

alias newpass='openssl rand -base64 14'
