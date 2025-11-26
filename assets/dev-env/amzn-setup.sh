#!/usr/bin/env zsh
#set -e  # not doing -e as some 'source' could return non-zero


# Cloud Desktop development environment auto setup script.


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
# Then, fetch this script and run it (now only interactive mode supported).
# 
#   ./amzn-setup.sh
#   
# Hit enter to continue whenever entering a new section, or Ctrl-C to kill if
# anything goes wrong.
# 
# After all done, log out and log back in. Should be all set!


# helper functions
function section_header {
    local section="$1"
    echo
    echo -n "\033[1;35m=> Start section\033[0m '$section'? [Enter] "
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

function change_git_email {
    local email="$1"
    sed -i "s/^    email = \(.*\)$/    email = $email/g" .gitconfig
}


# ensure in user home directory
cd $HOME

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

# make sure MidWay credentials fresh
echo "Refreshing MidWay credentials..."
mwinit -s -o


# yum installs
section_header "yum-installs"
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install gcc \
                    git \
                    make \
                    cmake \
                    curl \
                    wget \
                    vim \
                    htop \
                    openssl11 \
                    screen \
                    libevent \
                    ncurses \
                    mailx
sudo yum -y autoremove

# oh-my-zsh (do this first)
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

# mcurl
section_header "mcurl"
append_to_file .zshrc ""
append_to_file .zshrc "# mcurl"
cat >> .zshrc << EOF
function mcurl() {
    /usr/bin/curl "$@" -L --cookie ~/.midway/cookie --cookie-jar ~/.midway/cookie
}
EOF
reload_zshrc

# builders toolbox
section_header "builders-toolbox"
append_to_file .zshrc ""
append_to_file .zshrc "# builders toolbox"
toolbox install axe
reload_zshrc
axe init builder-tools
reload_zshrc

# brazil
section_header "brazil"
toolbox install brazilcli
brazil setup completion
sudo mkdir -p -m 755 /workplace/${USER}
sudo chown -R ${USER}:amazon /workplace/${USER}
ln -s /workplace/${USER} ~/workplace

# brazil aliases
section_header "brazil-aliases"
append_to_file .zshrc ""
append_to_file .zshrc "# brazil aliases"
cat >> .zshrc << EOF
alias bb=brazil-build
alias bbap='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias brca='brc --allPackages'
alias bws='brazil ws'
alias bwsync='brazil ws sync'
alias bwsymd='brazil ws sync -md'
alias bwsuse='bws use -p'
alias bwsuvs='bws use -vs'
alias bwscre='bws create -n'
alias bvs='brazil vs'
alias bbr='brc brazil-build'
alias bbra='brc --allPackages brazil-build'
EOF

# aws cli / ada
section_header "ada"
read "region?Enter default AWS region: "
read "account?Enter Isengard Account ID: "
[[ -n "$region" && -n "$account" ]] || { echo "Region or Account is empty"; exit 1; }
mkdir -p ".aws"
cat > ".aws/config" << EOF
[default]
region = $region
credential_process=ada credentials print --account $account --role Admin --provider isengard
EOF

# om
section_header "om"
mwinit -s -o && mcurl -Lo /tmp/c2j-model.json 'https://code.amazon.com/packages/AWSOMServiceModel/releases/1.0/latest_artifact?version_set=AWSOMService/development&path=smithyprojections/AWSOMServiceModel/aws-sdk-external/c2j/om-2018-05-10.json&download=true'
aws configure add-model --service-model file:///tmp/c2j-model.json --service-name om

# isengard cli
section_header "isengard-cli"
toolbox registry add s3://buildertoolbox-registry-isengard-cli-us-west-2/tools.json
toolbox install isengard-cli

# starship theme
section_header "starship"
sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y -b $HOME/.local/bin
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
wget https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz
tar -xzf tmux-3.5a.tar.gz
cd tmux-3.5a
./configure
make -j30
sudo make install
cd $HOME
rm tmux-3.5a.tar.gz
rm -rf tmux-3.5a
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
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-x86_64-linux-musl.tbz
mkdir -p .config/btop/
tar -xjf btop-x86_64-linux-musl.tbz -C .config/btop/
rm btop-x86_64-linux-musl.tbz
cd .config/btop/btop/
sudo make install
sudo make setcap
sudo make setuid
cd $HOME
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
wget https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-unknown-linux-musl.tar.gz
mkdir -p .config/delta/
tar -xzf delta-0.18.2-x86_64-unknown-linux-musl.tar.gz -C .config/delta/
rm delta-0.18.2-x86_64-unknown-linux-musl.tar.gz
cd .config/delta/delta-0.18.2-x86_64-unknown-linux-musl
sudo cp delta $HOME/.local/bin/
cd $HOME

# lstr tree
section_header "lstr"
git clone https://github.com/bgreenwell/lstr.git .lstr
cd .lstr
cargo install --path .
cd $HOME

# bat file viewer
section_header "bat"
cargo install --locked bat
mkdir -p .config/bat/
rm -f .config/bat/config
wget https://josehu.com/assets/dev-env/bat-config.txt -O .config/bat/config

# global gitconfig (with corporate name and email)
section_header "gitconfig"
rm -f .gitconfig
wget https://josehu.com/assets/dev-env/gitconfig.txt -O .gitconfig
read "gitemail?Enter git config email: "
[[ -n "$gitemail" ]] || { echo "Git email is empty"; exit 1; }
change_git_email "$gitemail"

# python uv
section_header "python-uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

# protobuf
section_header "protobuf"
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v32.1/protoc-32.1-linux-x86_64.zip
sudo unzip protoc-32.1-linux-x86_64.zip -d /usr/local
rm protoc-32.1-linux-x86_64.zip
sudo rm -f /usr/local/readme.txt
append_to_file .zshrc ""
append_to_file .zshrc "# protobuf"
append_to_file .zshrc "export PROTOC=/usr/local/bin/protoc"
reload_zshrc

# aps personal-stacks
section_header "aps-personal-stacks"
toolbox install personal-stacks

# claude code
section_header "claude-code"
curl -fsSL https://claude.ai/install.sh | bash
claude install
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
wget https://josehu.com/assets/dev-env/claude-code/settings.json -O ~/.claude/settings.json
wget https://josehu.com/assets/dev-env/claude-code/commands/catchup.txt -O ~/.claude/commands/catchup.md
wget https://josehu.com/assets/dev-env/claude-code/commands/prepare.txt -O ~/.claude/commands/prepare.md
wget https://josehu.com/assets/dev-env/claude-code/subagents/code-review.txt -O ~/.claude/agents/code-review.md

# openai codex
section_header "openai-codex"
npm i -g @openai/codex
mkdir -p ~/.codex/prompts
wget https://josehu.com/assets/dev-env/openai-codex/config.toml -O ~/.codex/config.toml
wget https://josehu.com/assets/dev-env/openai-codex/prompts/catchup.txt -O ~/.codex/prompts/catchup.md
wget https://josehu.com/assets/dev-env/openai-codex/prompts/prepare.txt -O ~/.codex/prompts/prepare.md
wget https://josehu.com/assets/dev-env/openai-codex/prompts/code-review.txt -O ~/.codex/prompts/code-review.md

# gemini cli
section_header "gemini-cli"
npm install -g @google/gemini-cli
mkdir -p ~/.gemini/commands
wget https://josehu.com/assets/dev-env/gemini-cli/settings.json -O ~/.gemini/settings.json
wget https://josehu.com/assets/dev-env/gemini-cli/commands/catchup.toml -O ~/.gemini/commands/catchup.toml
wget https://josehu.com/assets/dev-env/gemini-cli/commands/prepare.toml -O ~/.gemini/commands/prepare.toml
wget https://josehu.com/assets/dev-env/gemini-cli/commands/code-review.toml -O ~/.gemini/commands/code-review.toml

# emailme
section_header "emailme"
wget https://josehu.com/assets/dev-env/emailme.zsh -O ~/.local/bin/emailme
chmod a+x ~/.local/bin/emailme

# auto tmux not done
# section_header "auto-tmux"
# echo "Last step: auto start tmux on login in '.zshrc'..."
# append_to_file .zshrc ""
# append_to_file .zshrc "# auto tmux (keep at the bottom of .zshrc)"
# append_to_file .zshrc "test -z \"\$TMUX\" && (tmux attach || tmux new-session)"
