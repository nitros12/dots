set -xg NPM_PACKAGES "$HOME/.npm-packages"
set -xg XDG_CONFIG_HOME "$HOME/.config"
set -xg EDITOR nvim
set -xg CFLAGS "-march=native -mtune=native -O2 -pipe"
set -xg CXXFLAGS $CFLAGS
set -xg MAKEFLAGS "-j"
set -xg GOPATH $HOME/go
set -xg GRADLE_HOME ~/.gradle/wrapper/dists/gradle-5.1.1-bin
set -xg GRADLE_USER_HOME ~/.gradle
set -xg ERL_AFLAGS "-kernel shell_history enabled"
set -xg ENHANCD_FILTER fzf

set -U FZF_LEGACY_KEYBINDINGS 0

set -gx PATH
set -gx PATH /usr/local/bin /usr/local/sbin
set -gx PATH $PATH "$GOPATH/bin" "$HOME/.ghcup/bin" "/opt/cuda/bin" "$HOME/.poetry/bin" "$NPM_PACKAGES/bin" $HOME/.cargo/bin $HOME/.local/bin $HOME/.gem/ruby/2.5.0/bin /home/ben/.gem/ruby/2.6.0/bin /app/*
set -gx PATH /usr/bin /bin /usr/sbin /sbin $PATH

alias ls=exa
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls -T'
alias vim=nvim

alias ssh="assh wrapper ssh"

if test -d /opt/asdf-vm
  source /opt/asdf-vm/asdf.fish
  source /opt/asdf-vm/completions/asdf.fish
end

if which direnv &>/dev/null
  eval (direnv hook fish)
end

function start_tmux
  set PPID (echo (ps --pid %self -o ppid --no-headers) | xargs)
  if status --is-login
      if ps --pid $PPID | grep ssh
          tmux -2 start-server
          tmux -2 setenv -g IS_SSH_CONN 1
          tmux -2 source-file ~/.tmux.conf
          tmux -2 attach-session; or tmux -2 new-session; and kill %self
          echo "tmux failed to start; using plain fish shell"
      end
  else
    if not ps --pid $PPID | grep ssh && test -z "$TMUX" && test -z $TERMINAL_CONTEXT
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

