#!/bin/bash

# Print the hostname when exiting from an ssh connection
ssh() {
  local do_tmux=''
  if [ -n "$TMUX" ] && [ "$(tmux list-panes -F 'P')" = 'P' ]; then
    do_tmux='yeah boy'
  fi
  if [ -n "$do_tmux" ]; then
    local prefix="$(tmux display -p '#{prefix}')"
    local status_mode="$(tmux display -p '#{status}')"
    tmux set status off
    tmux set key-table nested
    tmux set prefix None
  fi
  command ssh "$@"
  local res=$?
  echo
  echo -e "Back on \033[38;5;${HOST_COLOR}m$(hostname -s)\033[0m as $(whoami)"
  if [ -n "$do_tmux" ]; then
    tmux set status "$status_mode"
    tmux set key-table root
    tmux set prefix "$prefix"
  fi
  return $res
}
