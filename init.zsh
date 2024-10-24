# Set default values if not already set
: ${TMUX_SESSIONIZER_DIRS:="$HOME/Developer"}
: ${TMUX_SESSIONIZER_BIND:="C-f"}
: ${TMUX_SESSIONIZER_DEPTH:=2}

function _tmux_sessionizer() {
  local selected_dir

  # Check if fd command exists, otherwise use find
  if (( ${+commands[fd]} )); then
    selected_dir=$(fd . ${(z)TMUX_SESSIONIZER_DIRS} -t d -d ${TMUX_SESSIONIZER_DEPTH} 2>/dev/null | fzf --reverse)
  else
    selected_dir=$(find ${(z)TMUX_SESSIONIZER_DIRS} -mindepth 1 -maxdepth ${TMUX_SESSIONIZER_DEPTH} -type d 2>/dev/null | fzf --reverse)
  fi

  if [[ -z "$selected_dir" ]]; then
    return 0
  fi

  local session_name=$(basename "$selected_dir" | tr . _)

  if [[ -z "$TMUX" ]]; then
    # If not in tmux, create a new session and attach to it
    tmux new-session -s "$session_name" -c "$selected_dir"
  else
    # If session doesn't exist, create it
    if ! tmux has-session -t="$session_name" 2> /dev/null; then
      tmux new-session -ds "$session_name" -c "$selected_dir"
    fi
    # Switch to the session
    tmux switch-client -t "$session_name"
  fi
}


# Initialize module
function init() {
  # Check dependencies
  local -a missing_deps=()
  
  if ! (( ${+commands[tmux]} )); then
    missing_deps+=( tmux )
  fi
  
  if ! (( ${+commands[fzf]} )); then
    missing_deps+=( fzf )
  fi
  
  if ! (( ${+commands[fd]} )) && ! (( ${+commands[find]} )); then
    missing_deps+=( fd )
  fi
  
  if (( ${#missing_deps} > 0 )); then
    print -P "%F{red}Tmux Sessionizer missing required dependencies:%f %F{yellow}${(j:, :)missing_deps}%f" >&2
    return 1
  fi

  # Create alias for direct use
  alias ts=_tmux_sessionizer

  # Add keybinding if inside tmux
  if [[ -n "$TMUX" ]]; then
    tmux bind-key "$TMUX_SESSIONIZER_BIND" display-popup -E "zsh -i -c ts"
  fi

  return 0
}

init "$@"
