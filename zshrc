# Path to your oh-my-zsh installation.
export ZSH="/Users/niels/.oh-my-zsh"

# update-uber-home.sh told me to do it
if command -v rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bazel)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

export BAT_THEME="Nord"

if [[ $EDITOR = "" ]]; then
	export EDITOR="nvim"
fi

export GOPATH=$HOME/gocode
export PATH=$GOPATH/bin:$PATH

echo -e "`date +"%Y-%m-%d %H:%M:%S"` direnv hooking zsh"
eval "$(direnv hook zsh)"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Add zls to path
export PATH=$HOME/zls:$PATH

# Add piper pipeline code to system python.
export PYTHONPATH=$HOME/Uber/data/piper:$PYTHONPATH

export MONOREPO_GOPATH_MODE=1

function gopathmode () {
	USAGE="$0 [ on | off ]\n\tshows or sets MONOREPO_GOPATH_MODE"
	[ $# -lt 1 ] && {
		[ -n "$MONOREPO_GOPATH_MODE" ] \
		&& echo "MONOREPO_GOPATH_MODE is on." \
		|| echo "MONOREPO_GOPATH_MODE is off."
		return
	}
	[ $# -gt 1 ] && echo "$USAGE" && return
	[ "$1" != "on" ] && [ "$1" != "off" ] && {
		echo "$USAGE"
		return
	}

	if [[ "$MONOREPO_GOPATH_MODE" != "1" && "$1" == "on" ]] ; then
		export MONOREPO_GOPATH_MODE=1
		repo=$(git config --get remote.origin.url || true)
		if [[ $repo =~ ":go-code" ]]; then
			direnv reload
		fi
	elif [[ -n "$MONOREPO_GOPATH_MODE" && "$1" == "off" ]] ; then
		unset MONOREPO_GOPATH_MODE
		repo=$(git config --get remote.origin.url || true)
		if [[ $repo =~ ":go-code" ]]; then
			direnv reload
		fi
	fi
}

source "$HOME/.bash_profile"

export PATH="$HOME/.poetry/bin:$PATH"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

function t() {
	session=$(basename $(pwd))
	clean_session=$(tr -c "[:alnum:]" "_" <<< "$session")
	if ! tmux has-session -t $clean_session > /dev/null
	then
		tmux new -s $clean_session
	else
		tmux attach -t $clean_session
	fi
}

function nzf() {
	nvim $(fzf -q $1)
}

function arcp() {
	git checkout main && git pull origin main && arc patch $1
}

if [[ -t 1 ]]
then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_green="$(tty_mkbold 32)"
tty_orange="$(tty_mkbold 33)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

info() {
	printf "${tty_blue}==>${tty_bold} %s${tty_reset} %s\n" $1 $2
}

error() {
	printf "${tty_red}Error:${tty_bold} %s\n" $1
}

function worktree() {
	local WORKTREE="$UBER_HOME/go-code-worktrees/$1"
	local GOCODE="$HOME/go-code"
	local PKG="src/code.uber.internal/$2"

	cd $GOCODE &> /dev/null

	info "Updating go-code" $GOCODE
	if ! git checkout main &> /dev/null
	then
		error "Failed to checkout main"
		return 1
	fi
	
	if ! git pull origin main &> /dev/null
	then
		error "Failed to pull origin main"
		return 1
	fi

	info "Creating new worktree" $WORKTREE
	if ! $GOCODE/bin/git-bzl new $GOCODE $WORKTREE $PKG &> /dev/null
	then
		error "Failed to create new worktree"
		return 1
	fi

	info "Copying .envrc.local" "$WORKTREE/.envrc.local"
	if ! cp .envrc.local "$WORKTREE/.envrc.local" &> /dev/null
	then
		error "Failed to copy .envrc.local"
		return 1
	fi

	info "Enabling .envrc" ""
	if ! direnv allow "$WORKTREE/.envrc" &> /dev/null
	then 
		error "Failed to enable .envrc"
		return 1
	fi

	cd "$WORKTREE" &> /dev/null

	info "Running setup-gopath" "//$PKG/..."
	$WORKTREE/bin/setup-gopath "//$PKG/..."
}

eval "$(zoxide init zsh)"

# opam configuration
[[ ! -r /Users/niels/.opam/opam-init/init.zsh ]] || source /Users/niels/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

plugins+=(zsh-vi-mode)

export BABASHKA_PRELOADS="(require '[cheshire.core :as json])"
