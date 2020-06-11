---
layout: post
title: "Personal Dev Environment & Tools Configuration on macOS X"
date: 2020-02-10 03:44:09
author: Guanzhou Hu
categories: Memo
---

This post summarizes my personal development environment configuration on macOS X. Just for memo. 记录一下我在 macOS X >= 10.14 上的个人开发环境 & 工具配置，以便将来需要时 refer。

### Summary Table

| Category | Choice |
|:--:|:--|
| Terminal software | iTerm2 |
| Shell | Z Shell: `zsh` |
| Dev Font | FiraCode Nerd Font |
| Package manager | Homebrew |
| Text editor | Sublime Text 3 (with Vim as auxilliary) |
| Markdown notebook | Typora |
| PDF reader | PDF Expert |
| Latex editor | Overleaf (online) |
| Office documents | MS Office 365 subscription |
| Chart drawing | ProcessOn, Draw.io, ... (online) |
| Cloud storage & sync | Dropbox, Google Drive |
| Communication | Slack, Zoom, QQ, Wechat, ... |
| Browser | Google Chrome |
| Code Distribution | GitHub, BitBucket |

### Z Shell

- Extension: `oh-my-zsh`
- Theme: Starship.rs (w/ customizations)
- Plugins:
    - autojump
    - zsh-syntax-highlighting
    - git
    - zsh-autosuggestions
    - sublime

`zsh` config (`~/.zshrc`):

```bash
# ~/.zshrc

# Path to your oh-my-zsh installation.
export ZSH="/Users/jose/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="minimal"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sublime autojump zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias lr="ls -lAh *"
alias lra="ls -lAhR *"

# iTerm 2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Autojump
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

# Starship Theme
eval "$(starship init zsh)"

# Homebrew Bottle Source
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
```

My starship theme customizations (`~/.config/starship.toml`):

```bash
# Git repo status.
[git_status]
style = "bold blue"

# Nerd Font symbols.
[aws]
symbol = "ﲳ "
style = "bold black"

[battery]
full_symbol = ""
charging_symbol = ""
discharging_symbol = ""

[conda]
symbol = " "
style = "bold black"

[crystal]
symbol = " "
style = "bold black"

[docker]
symbol = " "
style = "bold black"

[elixir]
symbol = " "
style = "bold black"

[elm]
symbol = " "
style = "bold black"

[erlang]
style = "bold black"

[git_branch]
symbol = "שׂ "

[golang]
symbol = " "
style = "bold black"

[haskell]
symbol = " "
style = "bold black"

[hg_branch]
symbol = " "

[java]
symbol = " "
style = "bold black"

[julia]
symbol = " "
style = "bold black"

[nix_shell]
symbol = " "
style = "bold black"

[nodejs]
symbol = " "
style = "bold black"

[package]
symbol = " "
style = "bold black"

[php]
symbol = " "
style = "bold black"

[python]
symbol = " "
style = "bold black"

[ruby]
symbol = " "
style = "bold black"

[rust]
symbol = " "
style = "bold black"

[cmd_duration]
prefix = "... ⏳ "

# Battery symbol.
[[battery.display]]
threshold = 20
```

> Special Nerd Font symbols may not appear correctly on this webpage.

### Sublime Text 3

- Theme: Monokai Pro (Filter Spectrum)
- Font: Fira Code (w/ Antalias)
- Packages (functional):
    - Package Control
    - Package Resource Viewer
    - Advanced New File
    - All Autocomplete
    - Bracket Highlighter
    - DocBlockr
    - SideBar Enhancements
    - Sublimerge 3
    - Word Count
- Packages (language support):
    - Anaconda
    - CMake Editor
    - CUDA C++
    - CUDA Snippets
    - Dockerfile
    - Easy Clang Complete
    - Golang Build
    - Julia
    - Linker Script
    - Makefile Improved
    - Rust Enhanced
    - Rust Autocomplete
    - TOML
    - x86 and x86_64 Assembly

Sublimt Text 3 user preferences settings:

```json
// Preferences.sublime-settings -- User

{
    "auto_complete": true,
    "auto_complete_commit_on_tab": true,
    "caret_extra_width": 0,
    "caret_style": "smooth",
    "close_windows_when_empty": false,
    "color_scheme": "Packages/Theme - Monokai Pro/Monokai Pro (Filter Spectrum).sublime-color-scheme",
    "copy_with_empty_selection": false,
    "font_face": "Fira Code",
    "font_options":
    [
        "subpixel_antialias",
        "gray_antialias"
    ],
    "font_size": 12,
    "highlight_line": true,
    "margin": 0,
    "save_on_focus_lost": true,
    "theme": "Monokai Pro (Filter Spectrum).sublime-theme",
    "translate_tabs_to_spaces": true,
    "update_check": false
}
```

### Vim

- Plugin manager: vim-plug
- Theme: Gruvbox

Vim user config (`~/.vimrc`):

```bash
# ~/.vimrc

syntax on

set showmode
set showcmd
set mouse=a
set encoding=utf-8
set t_Co=256

filetype indent on
set formatoptions-=t
set autoindent

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

set number
set relativenumber
set cursorline
set ruler

set wrapmargin=2
set scrolloff=5

set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

set nobackup
set noswapfile
set autochdir
set autoread

set wildmenu
set wildmode=longest:list,full

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox
set background=dark
```
