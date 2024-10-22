# Tmux Sessionizer 

Tmux Sessionizer stolen from ThePrimeagen.

## Prerequisites

- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd) (optional, falls back to `find`)

## Installation

1. Add the following to your `~/.zimrc`:
```zsh
zmodule nikevsoft/tmux-sessionizer
```

2. Install the module:
```zsh
zimfw install
```

## Configuration

You can customize the module by setting these variables in your `.zshrc` before the module is loaded:

```zsh
# Set the directories to search (default: $HOME/Developer)
TMUX_SESSIONIZER_DIRS="$HOME/Developer $HOME/Work"

# Change the default keybinding (default: Ctrl+f)
TMUX_SESSIONIZER_BIND="C-f"

# Set the directory search depth (default: 2)
TMUX_SESSIONIZER_DEPTH=3  # Will search 3 levels deep
```

## Usage

- Use the `ts` command directly
- Press `<prefix> Ctrl+f` (or your custom keybinding) to open the session selector in a popup window

