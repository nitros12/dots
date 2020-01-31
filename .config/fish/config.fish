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
set -gx PATH /usr/local/bin /usr/local/sbin
set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
set -gx PATH $PATH "/opt/cuda/bin" "$HOME/.poetry/bin" "$NPM_PACKAGES/bin" $HOME/.cargo/bin $HOME/.local/bin $HOME/.gem/ruby/2.5.0/bin /home/ben/.gem/ruby/2.6.0/bin /app/*
set -gx PATH $PATH /usr/bin /bin /usr/sbin /sbin /opt/local/bin /opt/local/sbin

alias ls=exa
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls -T'
alias vim=nvim

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

source ~/.iterm2_shell_integration.fish

function start_tmux
  set PPID (echo (ps -T -p %self -o ppid=) | xargs)
  if status --is-login
      if ps -T -p $PPID | grep ssh
          tmux -2 start-server
          tmux -2 setenv -g IS_SSH_CONN 1
          tmux -2 source-file ~/.tmux.conf
          tmux -2 attach-session; or tmux -2 new-session; and kill %self
          echo "tmux failed to start; using plain fish shell"
      end
  else
    if not ps -T -p $PPID | grep ssh && test -z "$TMUX" && test -z $TERMINAL_CONTEXT
        tmux -2 start-server
        tmux -2 setenv -gru IS_SSH_CONN
        tmux source-file ~/.tmux.conf
        exec tmux new-session -A -s local
    end
  end
end


# for when we ssh into this machine through emacs tramp
if test "$TERM" = "dumb" || test "$TERM" = ""
  function fish_prompt
    echo "\$ "
  end

  function fish_right_prompt; end
  function fish_greeting; end
  function fish_title; end
else
  eval (starship init fish)
  start_tmux
end
