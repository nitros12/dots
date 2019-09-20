set -xg NPM_PACKAGES "$HOME/.npm-packages"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -xg PATH "/opt/cuda/bin $HOME/.poetry/bin" "$NPM_PACKAGES/bin" $HOME/.cargo/bin $HOME/.local/bin $HOME/.gem/ruby/2.5.0/bin /app/* $PATH
set -xg EDITOR nvim
set -xg CFLAGS "-march=native -mtune=native -O2 -pipe"
set -xg CXXFLAGS $CFLAGS
set -xg MAKEFLAGS "-j9"
set -xg GOPATH $HOME/go
set -xg GRADLE_HOME ~/.gradle/wrapper/dists/gradle-5.1.1-bin
set -xg GRADLE_USER_HOME ~/.gradle
set -xg ERL_AFLAGS "-kernel shell_history enabled"

set -U FZF_LEGACY_KEYBINDINGS 0

function ls
    exa $argv
end

function ll
    exa -l $argv
end

function la
    exa -a $argv
end

function lla
    exa -al $argv
end

function lt
    exa -T $argv
end

function vim
    nvim $argv
end

# pip fish completion start
function __fish_complete_pip
    set -lx COMP_WORDS (commandline -o) ""
    set -lx COMP_CWORD (math (contains -i -- (commandline -t) $COMP_WORDS)-1)
    set -lx PIP_AUTO_COMPLETE 1
    string split \  -- (eval $COMP_WORDS[1])
end
complete -fa "(__fish_complete_pip)" -c pip
# pip fish completion end

alias git=hub

# for when we ssh into this machine through emacs tramp
if test "$TERM" = "dumb"
  function fish_prompt
    echo "\$ "
  end

  function fish_right_prompt; end
  function fish_greeting; end
  function fish_title; end
end

set SPACEFISH_HASKELL_SHOW false

set SPACEFISH_USER_COLOR "blue"
set SPACEFISH_USER_SHOW "always"

set SPACEFISH_CHAR_SYMBOL "λ"
set SPACEFISH_CHAR_COLOR_SUCCESS "purple"

set SPACEFISH_GIT_BRANCH_COLOR "green"
set SPACEFISH_GIT_STATUS_PREFIX " ("
set SPACEFISH_GIT_STATUS_SUFFIX " )"
set SPACEFISH_GIT_STATUS_COLOR "blue"

set SPACEFISH_GIT_STATUS_UNTRACKED " untracked"
set SPACEFISH_GIT_STATUS_MODIFIED  " unstaged"
set SPACEFISH_GIT_STATUS_ADDED     " added"
set SPACEFISH_GIT_STATUS_RENAMED   " renamed"
set SPACEFISH_GIT_STATUS_DELETED   " deleted"
set SPACEFISH_GIT_STATUS_STASHED   " stashed"
set SPACEFISH_GIT_STATUS_UNMERGED  " unmerged"


set SPACEFISH_HASKELL_COLOR "yellow"

function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

start_tmux
