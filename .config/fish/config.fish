set -xg NPM_PACKAGES "$HOME/.npm-packages"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -xg EDITOR nvim
set -xg CFLAGS "-march=native -mtune=native -O2 -pipe"
set -xg CXXFLAGS $CFLAGS
set -xg MAKEFLAGS "-j9"
set -xg GOPATH $HOME/go
set -xg GRADLE_HOME ~/.gradle/wrapper/dists/gradle-5.1.1-bin
set -xg GRADLE_USER_HOME ~/.gradle
set -xg ERL_AFLAGS "-kernel shell_history enabled"

set -U FZF_LEGACY_KEYBINDINGS 0

set -gx PATH
set -gx PATH /user/local/bin /usr/local/sbin
set -gx PATH $PATH "/opt/cuda/bin" "$HOME/.poetry/bin" "$NPM_PACKAGES/bin" $HOME/.cargo/bin $HOME/.local/bin $HOME/.gem/ruby/2.5.0/bin /app/*
set -gx PATH /usr/bin /bin /usr/sbin /sbin $PATH

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
else
  eval (starship init fish)
end

function start_tmux
  if status --is-login
      set PPID (echo (ps --pid %self -o ppid --no-headers) | xargs)
      if ps --pid $PPID | grep ssh
          set -g IS_SSH_CONN 1
          tmux -2 start-server
          tmux -2 setenv -g IS_SSH_CONN 1
          tmux -2 source-file ~/.tmux.conf
          tmux -2 attach-session; or tmux -2 new-session; and kill %self
          echo "tmux failed to start; using plain fish shell"
      end
  else
    if ps --pid $PPID | grep ssh && test -z "$TMUX" && test -z $TERMINAL_CONTEXT
        set -ge IS_SSH_CONN
        tmux -2 start-server
        tmux -2 setenv -gru IS_SSH_CONN
        tmux source-file ~/.tmux.conf
        exec tmux new-session -A -s local
    end
  end
end

start_tmux
