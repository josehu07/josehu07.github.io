#!/usr/bin/env zsh
#set -e  # not doing -e as some 'source' could return non-zero


# Usage:
#
# First, ensure that zsh and vim are there. Switch default shell to zsh.
# 
#   which zsh
#   which vim
#   chsh -s $(which zsh)
# 
# Logout and log back in to ensure we are now using zsh.
# 
#   # select 0 if menu appears
#   echo $SHELL
# 
# Then, fetch this script and run it ('-y' for non-interactive mode).
# 
#   ./auto-setup.sh [-y]
#   
# Hit enter to continue whenever entering a new section, or Ctrl-C to kill if
# anything goes wrong.
# 
# After all done, log out and log back in. Should be all set!


# helper functions
non_interactive=false

function section_header {
    local section="$1"
    echo
    if [[ $non_interactive == true ]]; then
        echo "\033[1;35m=> Starting section\033[0m '$section'..."
    else
        echo -n "\033[1;35m=> Start section\033[0m '$section'? [Enter] "
        read response
    fi
}

function reload_zshrc {
    source .zshrc
}

function append_to_file {
    local file="$1"
    local line="$2"
    echo $line >> $file
}

function add_zsh_plugin {
    local plugin="$1"
    sed -i "s/^plugins=(\(.*\))/plugins=(\1 $plugin)/g" .zshrc
}


# ensure in user home directory
cd $HOME

# check if running in non-interactive mode
for arg in "$@"; do
    if [[ $arg == "-y" ]]; then
        echo "Running non-interactively, breakpoints will be skipped."
        non_interactive=true
    fi
done

# check that we are now in zsh
if [[ -n $SHELL ]] && [[ "$(basename $SHELL)" != "zsh" ]]; then
    echo "ERROR: SHELL variable not set or not using zsh!"
    echo
    echo "Please do:"
    echo "  chsh -s \$(which zsh)"
    echo "  # log out and log back in, select 0 if menu appears"
    echo "  echo \$SHELL"
    echo
    exit 1
fi


# apt installs
section_header "apt-installs"
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install build-essential \
                    git \
                    cmake \
                    curl \
                    vim \
                    htop \
                    tmux \
                    screen
sudo apt -y autoremove
sudo apt -y autoclean

# oh-my-zsh
section_header "oh-my-zsh"
rm -rf ./.oh-my-zsh/
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
reload_zshrc

# turn off flow control
section_header "flow-control"
echo "Adding 'stty -ixon' to turn off flow control..."
append_to_file .zshrc ""
append_to_file .zshrc "# turn off flow control"
append_to_file .zshrc "stty -ixon"
reload_zshrc

# starship theme
section_header "starship"
sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
eval "$(starship init zsh)"
mkdir -p .config/
rm -f .config/starship.toml
wget https://josehu.com/assets/dev-env/starship.toml -P .config/
append_to_file .zshrc ""
append_to_file .zshrc "# starship theme"
append_to_file .zshrc "eval \"\$(starship init zsh)\""
reload_zshrc

# zoxide jump
section_header "zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
append_to_file .zshrc ""
append_to_file .zshrc "# zoxide"
append_to_file .zshrc "export PATH=\$PATH:\$HOME/.local/bin"
append_to_file .zshrc "eval \"\$(zoxide init zsh)\""
reload_zshrc

# zsh-syntax-highlighting
section_header "zsh-syntax-highlighting"
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
add_zsh_plugin "zsh-syntax-highlighting"
reload_zshrc

# zsh-autosuggestions
section_header "zsh-autosuggestions"
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
add_zsh_plugin "zsh-autosuggestions"
reload_zshrc

# colored-man-pages
section_header "colored-man-pages"
add_zsh_plugin "colored-man-pages"
reload_zshrc

# vim setup
section_header "vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
rm -f .vimrc
wget https://josehu.com/assets/dev-env/vimrc-backup.txt -O .vimrc
vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"

# tmux setup
section_header "tmux"
rm -f .tmux.conf
wget https://josehu.com/assets/dev-env/tmux.conf -O .tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone -b v2.1.3 https://github.com/catppuccin/tmux ~/.tmux/plugins/catppuccin/tmux

# screen setup
section_header "screen"
rm -f .screenrc
wget https://josehu.com/assets/dev-env/screenrc.txt -O .screenrc

# rust toolchain
section_header "rust-toolchain"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
append_to_file .zshrc ""
append_to_file .zshrc "# rust cargo"
append_to_file .zshrc ". \"\$HOME/.cargo/env\""
reload_zshrc
rustup update

# btop monitor
section_header "btop"
sudo apt -y install btop
mkdir -p .config/btop/
rm -f .config/btop/btop.conf
wget https://josehu.com/assets/dev-env/btop.conf -P .config/btop/

# fzf search
section_header "fzf-search"
git clone --depth 1 https://github.com/junegunn/fzf.git .fzf
.fzf/install --key-bindings --completion --no-update-rc
append_to_file .zshrc ""
append_to_file .zshrc "# fzf search"
append_to_file .zshrc "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh"
append_to_file .zshrc "export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'"
reload_zshrc

# delta diff pager
section_header "delta-diff"
sudo apt -y install git-delta

# lstr tree
section_header "lstr"
git clone https://github.com/bgreenwell/lstr.git .lstr
cd .lstr
cargo install --path .
cd ..

# bat file viewer
section_header "bat"
sudo apt -y install bat
mkdir -p .config/bat/
rm -f .config/bat/config
wget https://josehu.com/assets/dev-env/bat-config.txt -O .config/bat/config

# global gitconfig
section_header "gitconfig"
rm -f .gitconfig
wget https://josehu.com/assets/dev-env/gitconfig.txt -O .gitconfig

# python uv
section_header "python-uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

# claude code
section_header "claude-code"
curl -fsSL https://claude.ai/install.sh | bash
claude installmkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
wget https://josehu.com/assets/dev-env/claude-code/settings.json -O ~/.claude/settings.json
wget https://josehu.com/assets/dev-env/claude-code/commands/catchup.txt -O ~/.claude/commands/catchup.md
wget https://josehu.com/assets/dev-env/claude-code/commands/prepare.txt -P ~/.claude/commands/prepare.md
wget https://josehu.com/assets/dev-env/claude-code/subagents/code-review.txt -P ~/.claude/agents/code-review.md

# auto tmux (last step)
section_header "auto-tmux"
echo "Last step: auto start tmux on login in '.zshrc'..."
append_to_file .zshrc ""
append_to_file .zshrc "# auto tmux (keep at the bottom of .zshrc)"
append_to_file .zshrc "test -z \"\$TMUX\" && (tmux attach || tmux new-session)"
