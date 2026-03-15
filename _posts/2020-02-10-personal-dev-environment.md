---
layout: post
title: "Personal Dev Environment & Tools Configuration Record"
date: 2020-02-10 03:44:09
author: Guanzhou Hu
categories: Memo
---

WARNING: this post is seriously outdated, and my dev setup has been evolving a lot with time. For a partial glance, you may check out my [assets/dev-env/auto-setup.zsh](https://josehu.com/assets/dev-env/auto-setup.zsh).

This post summarizes my personal development environment configuration on macOS X >= 10.14 and includes a brief memo of setting up WSL 2 on Windows >= 10. 记录一下我在 macOS X >= 10.14 上的个人开发环境 & 工具配置，以及在 Windows >= 10 上搭建基于 WSL 2 的开发环境的简要过程，以便将来需要时 refer。

## Summary Table

| Category | Choice |
|:--:|:--|
| Terminal software | iTerm2 / Windows Terminal |
| Shell | Z Shell: `zsh` |
| Dev Font | FiraCode Nerd Font |
| Package manager | Homebrew / APT |
| Text editor | VS Code (works like charm w/ WSL), Sublime Text, Vim |
| Markdown notebook | Typora |
| PDF reader | PDF Expert / Adobe Acrobat |
| Latex editor | Overleaf (online) |
| Office documents | MS Office 365 subscription |
| Chart drawing | ProcessOn, Draw.io, ... (online) |
| Cloud storage & sync | Dropbox, Google Drive |
| Communication | Slack, Zoom, QQ, Wechat, ... |
| Browser | Google Chrome |
| Code Distribution | GitHub, BitBucket |

## Auto Setup Script

For easy setup on e.g. CloudLab servers, I uploaded a setup script to help handle everything automatically. Please follow the steps stated below.

First, verify that `zsh` and `vim` are already there:

```bash
which zsh
which vim
```

Change default shell to `zsh` by:

```bash
chsh -s $(which zsh)
```

Logout and log back in. If a menu appears (on the first time we switch to `zsh`), select `0`.

```bash
echo $SHELL
```

Then, fetch and run the auto setup script:

```bash
wget https://josehu.com/assets/dev-env/dev-env-setup.sh
chmod +x dev-env-setup.sh
./dev-env-setup.sh
```

Hit enter to continue whenever entering a new section, or Ctrl-C to kill if anything goes wrong.

> Note that after `oh-my-zsh` installation, it automatically starts a new shell session, so we have to give it an `exit` command to exit out, and the rest of the script should continue seamlessly.

After all sections are done, log out and log back in. Should be all set!

## Z Shell

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
autoload -U compinit && compinit -u

# Starship Theme
eval "$(starship init zsh)"

# Homebrew Bottle Source
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
```

My starship theme customizations (`~/.config/starship.toml`):

```bash
# Username.
[username]
format = "[$user]($style) @ "

[hostname]
ssh_symbol = " "

# Git & related.
[git_status]
style = "bold blue"

[git_branch]
symbol = "שׂ "

[git_commit]
tag_symbol = " 笠 "

[hg_branch]
symbol = "שׂ "

# Return status.
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[✗](bold red)"

# Timing.
[cmd_duration]
format = "... ⏳ [$duration]($style)"

# Battery.
[[battery.display]]
threshold = 20

# Nerd Font symbols.
[aws]
symbol = "ﲳ "
style = "bold black"

[azure]
symbol = "ﴃ "
style = "bold black"

[buf]
symbol = " "
style = "bold black"

[c]
symbol = "C "
style = "bold black"

[cmake]
symbol = "△ "
style = "bold black"

[conda]
symbol = " "
style = "bold black"

[crystal]
symbol = " "
style = "bold black"

[dart]
symbol = " "
style = "bold black"

[deno]
symbol = " "
style = "bold black"

[docker_context]
symbol = " "
style = "bold black"

[dotnet]
symbol = ".NET "
style = "bold black"

[elixir]
symbol = " "
style = "bold black"

[elm]
symbol = " "
style = "bold black"

[erlang]
symbol = " "
style = "bold black"

[gcloud]
symbol = "ﲳ "
style = "bold black"

[golang]
symbol = " "
style = "bold black"

[haskell]
symbol = "λ "
style = "bold black"

[helm]
symbol = "⎈ "
style = "bold black"

[java]
symbol = " "
style = "bold black"

[julia]
symbol = " "
style = "bold black"

[kotlin]
symbol = "擄 "
style = "bold black"

[kubernetes]
symbol = "ﴱ "
style = "bold black"

[lua]
symbol = " "
style = "bold black"

[nim]
symbol = " "
style = "bold black"

[nix_shell]
symbol = " "
style = "bold black"

[nodejs]
symbol = " "
style = "bold black"

[ocaml]
symbol = " "
style = "bold black"

[openstack]
symbol = "ﲳ "
style = "bold black"

[package]
symbol = " "
style = "bold black"

[perl]
symbol = " "
style = "bold black"

[php]
symbol = " "
style = "bold black"

[pulumi]
symbol = " "
style = "bold black"

[purescript]
symbol = "<=> "
style = "bold black"

[python]
symbol = " "
style = "bold black"

[rlang]
symbol = " "
style = "bold black"

[red]
symbol = "卑 "
style = "bold black"

[ruby]
symbol = " "
style = "bold black"

[rust]
symbol = " "
style = "bold black"

[scala]
symbol = " "
style = "bold black"

[singularity]
symbol = "🆂 "
style = "bold black"

[spack]
symbol = "🅢 "
style = "bold black"

[swift]
symbol = " "
style = "bold black"

[terraform]
symbol = "行 "
style = "bold black"

[vagrant]
symbol = "⍱ "
style = "bold black"

[vlang]
symbol = "V "
style = "bold black"

[zig]
symbol = "↯ "
style = "bold black"
```

> Special Nerd Font symbols may not appear correctly on this webpage. Copying + pasting should still work.

## Visual Studio Code

With the help of the seamless "Remote - WSL" extension, VS Code works like charm with WSL 2 under Windows 11. To my personal preference, the combination of a Win 11 workstation and WSL 2 + VS Code as the development environment is so far the best setup for a personal computer -- you enjoy both powerful gaming and powerful coding all at once.

Another good thing about VS Code is its strong capability of remote development on an SSH target. As this is what I do daily, using VS Code with its "Remote - SSH" extension saves me a ton of time from `scp`ing and `rsync`ing code between my local host and the remote targets.

Since VS Code syncs settings through the signed-in account, there's pretty much no need to record them down here.

## Sublime Text 4

- Theme: Monokai Pro (Filter Spectrum)
- Font: Fira Code (w/ Antaliasing & Ligatures)
- Packages (functional):
  - Package Control
  - Package Resource Viewer
  - Advanced New File
  - All Autocomplete
  - Bracket Highlighter
  - DocBlockr
  - SideBar Enhancements
  - Sublimerge 4
  - Word Count
  - View in Browser
- Packages (language support):
  - Anaconda
  - CMake Editor
  - CUDA C++
  - Dockerfile
  - Easy Clang Complete
  - Golang Build
  - Javascript Snippets
  - Jinja2
  - JsFormat
  - Julia
  - Linker Script
  - Makefile Improved
  - Markdown Preview
  - Power Shell
  - Rust Enhanced
  - LSP w/ Rust Analyzer
  - TOML
  - Typescript
  - Verilog
  - x86 and x86_64 Assembly

Sublimt Text 4 user preferences settings:

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
    "translate_tabs_to_spaces": true
}
```

Sublime Text 4 user key bindings:

```json
[
    { "keys": ["ctrl+k", "ctrl+m"], "command": "toggle_menu" },
]
```

## Vim

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

## Windows 10/11 with WSL2

First, download the following:

- Sublime Text 4
- Windows Terminal (from MS Store)
- Ubuntu 20.04 LTS (from MS Store)

> To fix Sublime Text title bar inactive color, follow this link: [https://winaero.com/blog/change-color-of-inactive-title-bars-in-windows-10/](https://winaero.com/blog/change-color-of-inactive-title-bars-in-windows-10/).

> Yet, I don't know how to change the menu bar color. Hiding it partially fixes the problem.

Install the Chocolatey package manager `choco`. Then, install both *Fira Code* and *FiraCode Nerd Font* by:

```bash
# Do this in an administrative PowerShell!
choco install firacode
choco install firacodenf
```

> On OS X, installing only the patched *FiraCode Nerd Font* works just fine, but here we need both of them. What I will be doing here is that I use Nerd Font in Windows Terminal and the original Fira Code in Sublime Text. This is the only way I got this around. Sigh...

Open "Turn Windows features on or off" from start menu, and check the following options:

- "Windows HyperV"
- "Windows Subsystem for Linux"

Launch the Ubuntu app in MS Store and wait for the initialization installation to complete. Then, in a Powershell terminal, use:

```bash
wsl -l -v
```

to check the Linux subsystems versions, and use:

```bash
wsl --set-version Ubuntu-20.04 2
```

to switch to WSL 2 permanently. There might be some extra installation prompting up - just follow them as well.

Open Windows Terminal and open its settings `json` file. Change the `defaultProfile` field to:

```json
    "defaultProfile": "{guid-of-your-Ubuntu-profile}",  // Copy your Ubuntu guid here from below.
```

and add to your Ubuntu profile section a `startingDirectory` field:

```json
            {
                "guid": "{guid-of-your-Ubuntu-profile}",
                "hidden": false,
                ...
                "startingDirectory": "\\\\wsl$\\Ubuntu-20.04\\home\\<username>"     // Change start dir to `~`.
            }
```

Add to the `default` region the following options:

```json
        "defaults":
        {
            // Put settings here that you want to apply to all profiles.
            "fontFace": "FiraCode NF",    // Change font face to FiraCode Nerd Font.
            "fontSize": 11,
            "background": "#242424"
        },
```

Then, close and reopen Windows Terminal. You should enter a default profile of Ubuntu 20.04 subsystem automatically, and should be in the home `~` directory. Install Zsh and all the other tools/themes as desired.

Currently, Windows Terminal does not support proper bold text display yet. It treats bold text as "brighter" text, like in some older terminal software. Still waiting for future updates on Windows Terminal...
