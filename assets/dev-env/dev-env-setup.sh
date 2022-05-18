#!/usr/bin/env zsh

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
# Then, fetch this script and run it.
# 
#   ./dev-env-setup.sh
#   
# Hit enter to continue whenever entering a new section, or Ctrl-C to kill if
# anything goes wrong.
# 
# After all done, log out and log back in. Should be all set!


function section_header {
    local section="$1"
    echo
    echo -n "=> Start section $section? [Enter] "
    read response
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


cd $HOME


# check that we are now in zsh
if [[ "$(basename $SHELL)" != "zsh" ]]; then
    echo "ERROR: currently not in zsh!"
    echo
    echo "Please do:"
    echo "  chsh -s \$(which zsh)"
    echo "  # log out and log back in, select 0 if menu appears"
    echo "  echo \$SHELL"
    echo
    exit 1
fi

# apt updates
section_header "apt-updates"
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt -y autoclean

# oh-my-zsh
section_header "oh-my-zsh"
echo "README: oh-my-zsh automatically enters a new zsh session after"
echo "        its installation script finishes; when that happens,"
echo "        immediately use 'exit' command to exit out of that session,"
echo "        then this setup script should continue seamlessly... "
rm -rf ./.oh-my-zsh/
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
reload_zshrc

# starship theme
section_header "starship"
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
eval "$(starship init zsh)"
mkdir -p .config/
rm -f .config/starship.toml
wget https://josehu.com/assets/dev-env/starship.toml -P .config/
append_to_file .zshrc ""
append_to_file .zshrc "# starship theme"
append_to_file .zshrc "eval \"\$(starship init zsh)\""
reload_zshrc

# autojump
section_header "autojump"
rm -rf autojump/
git clone https://github.com/wting/autojump.git
cd autojump
./install.py
cd ..
append_to_file .zshrc ""
append_to_file .zshrc "# autojump"
append_to_file .zshrc "[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh"
append_to_file .zshrc "autoload -U compinit && compinit -u"
rm -rf autojump/
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

# vim-plug
section_header "vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# gruvbox theme
section_header "gruvbox"
rm -f .vimrc
wget https://josehu.com/assets/dev-env/vimrc-backup.txt -O .vimrc
vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"
