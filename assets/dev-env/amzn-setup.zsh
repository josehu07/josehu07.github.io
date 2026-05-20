#!/bin/zsh
#set -e  # not doing -e as some 'source' could return non-zero


##
# Usage: assumes AL2023 dev desktop!
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
# Then, fetch this script and run it (now only interactive mode is supported).
# 
#   ./amzn-setup.zsh
#   
# Hit enter to continue whenever entering a new section, or Ctrl-C to kill if
# anything goes wrong.
# 
# After all done, log out and log back in. Should be all set!
##

##
# Personal next steps:
#   - remove compinit line in .zshrc
#   - uninstall toolbox rust-analyzer and install rustup component
#   - point VSCode rust-analyzer.server.path to cargo bin ver
#   - fill .aws/config with useful profile sections, copy existing
#   - add `zmodload zsh/zprof` / `zprof` pair and `ZSH_DISABLE_COMPFIX=true`
#   - change remote hostname display in starship config
#   - add `export AWS_EC2_METADATA_DISABLED=true` to disable IMDS
#   - kiro-cli: https://docs.hub.amazon.dev/kiro/user-guide/getting-started-cli/
#   - envImprovement: https://w.amazon.com/index.php/EnvImprovementNinjaBasics
#   - emailme: https://w.amazon.com/bin/view/AmazES/RoutingLayer/TheMystiqueReloaded/dev-dekstop-emails/
#   - auto S3 backup: https://w.amazon.com/index.php/DevDesktopS3Backup
#   - edit welcome message via `/etc/motd` to add host name
#   - import `.zsh_history` from older dev desktop so we can reuse command history
##


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


# dnf installs
section_header "dnf-installs"
sudo dnf -y upgrade
sudo dnf -y install gcc \
                    git \
                    make \
                    cmake \
                    wget \
                    vim \
                    htop \
                    openssl-devel \
                    screen \
                    libevent \
                    libevent-devel \
                    ncurses \
                    mailx \
                    postfix \
                    screen

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
    /usr/bin/curl "\$@" -L --cookie ~/.midway/cookie --cookie-jar ~/.midway/cookie
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
toolbox update

# SAM CLI
section_header "sam-cli"
wget -O aws-sam-cli.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip  # or arm64
unzip aws-sam-cli.zip -d sam-cli
sudo ./sam-cli/install
rm -f aws-sam-cli.zip

# LPT CLI
section_header "lpt-cli"
toolbox install --force-os=alinux lpt

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
alias bbb='brazil-build build'
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
alias bwshow='bws show'
alias bwsrmp='bws remove -p'
alias bwscln='bws clean'
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
credential_process = ada credentials print --account $account --role Admin --provider isengard
EOF

# om
section_header "om"
mkdir -p cli-models
mcurl -Lo cli-models/c2j-model.json 'https://code.amazon.com/packages/AWSOMServiceModel/releases/1.0/latest_artifact?version_set=AWSOMService/development&path=smithyprojections/AWSOMServiceModel/aws-sdk-external/c2j/om-2018-05-10.json&download=true'
aws configure add-model --service-model file:///home/${USER}/cli-models/c2j-model.json --service-name om

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
append_to_file .zshrc ""
append_to_file .zshrc "# set vim as default editor"
append_to_file .zshrc "export EDITOR=vim"
reload_zshrc

# tmux setup
section_header "tmux"
wget https://github.com/tmux/tmux/releases/download/3.6a/tmux-3.6a.tar.gz
tar -xzf tmux-3.6a.tar.gz
mv tmux-3.6a tmux-3.6a
cd tmux-3.6a
./configure
make -j30
sudo make install
cd $HOME
rm tmux-3.6a.tar.gz
rm -rf tmux-3.6a
rm -f .tmux.conf
wget https://josehu.com/assets/dev-env/tmux.conf -O .tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone -b v2.3.0 https://github.com/catppuccin/tmux ~/.tmux/plugins/catppuccin/tmux

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
rustup toolchain install nightly

# btop monitor
section_header "btop"
wget -O btop-linux.tar.gz https://github.com/aristocratos/btop/releases/download/v1.4.7/btop-x86_64-unknown-linux-musl.tar.gz  # or aarch64
mkdir -p .config/btop/
tar -xzf btop-linux.tar.gz -C .config/btop/
rm btop-linux.tar.gz
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
wget https://github.com/dandavison/delta/releases/download/0.19.2/delta-0.19.2-x86_64-unknown-linux-musl.tar.gz  # or aarch64 gnu
mkdir -p .config/delta/
tar -xzf delta-0.19.2-x86_64-unknown-linux-musl.tar.gz -C .config/delta/
rm delta-0.19.2-x86_64-unknown-linux-musl.tar.gz
cd .config/delta/delta-0.19.2-x86_64-unknown-linux-musl
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

# kubectl
section_header "kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  # or arm64
mv kubectl ~/.local/bin/
chmod a+x ~/.local/bin/kubectl
append_to_file .zshrc ""
append_to_file .zshrc "# kubectl"
append_to_file .zshrc "export <(kubectl completion zsh)"
reload_zshrc

# protobuf
section_header "protobuf"
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v35.0/protoc-35.0-linux-x86_64.zip  # or aarch_64
sudo unzip protoc-35.0-linux-x86_64.zip -d /usr/local
rm protoc-35.0-linux-x86_64.zip
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
mkdir -p ~/.claude/hooks
wget https://josehu.com/assets/dev-env/claude-code/settings.json -O ~/.claude/settings.json
wget https://josehu.com/assets/dev-env/claude-code/commands/catchup.txt -O ~/.claude/commands/catchup.md
wget https://josehu.com/assets/dev-env/claude-code/commands/prepare.txt -O ~/.claude/commands/prepare.md
wget https://josehu.com/assets/dev-env/claude-code/subagents/code-review.txt -O ~/.claude/agents/code-review.md
wget https://josehu.com/assets/dev-env/claude-code/hooks/mw-check.sh -O ~/.claude/hooks/mw-check.sh
chmod a+x ~/.claude/hooks/mw-check.sh

# openai codex
section_header "openai-codex"
npm i -g @openai/codex
mkdir -p ~/.codex/prompts
wget https://josehu.com/assets/dev-env/openai-codex/config.toml -O ~/.codex/config.toml
wget https://josehu.com/assets/dev-env/openai-codex/prompts/catchup.txt -O ~/.codex/prompts/catchup.md
wget https://josehu.com/assets/dev-env/openai-codex/prompts/prepare.txt -O ~/.codex/prompts/prepare.md
wget https://josehu.com/assets/dev-env/openai-codex/prompts/code-review.txt -O ~/.codex/prompts/code-review.md

# # gemini cli
# section_header "gemini-cli"
# npm install -g @google/gemini-cli
# mkdir -p ~/.gemini/commands
# wget https://josehu.com/assets/dev-env/gemini-cli/settings.json -O ~/.gemini/settings.json
# wget https://josehu.com/assets/dev-env/gemini-cli/commands/catchup.toml -O ~/.gemini/commands/catchup.toml
# wget https://josehu.com/assets/dev-env/gemini-cli/commands/prepare.toml -O ~/.gemini/commands/prepare.toml
# wget https://josehu.com/assets/dev-env/gemini-cli/commands/code-review.toml -O ~/.gemini/commands/code-review.toml

# builder mcp
section_header "builder-mcp"
toolbox install aim
aim mcp install builder-mcp
append_to_file .zshrc ""
append_to_file .zshrc "# AIM CLI"
append_to_file .zshrc "export PATH=\"/local/home/josehgz/.aim/mcp-servers:\$PATH\""
reload_zshrc

# kiro cli
section_header "kiro-cli"
toolbox uninstall q
toolbox install kiro-cli
toolbox install mcp-registry
mcp-registry install builder-mcp

# mechanic patching
section_header "mechanic"
toolbox install mechanic
mechanic configure completion
append_to_file .zshrc ""
append_to_file .zshrc "# mechanic"
append_to_file .zshrc "[ -f \"\$HOME/.local/share/mechanic/complete.zsh\" ] && source \"\$HOME/.local/share/mechanic/complete.zsh\""
reload_zshrc

# emailme
section_header "emailme"
wget https://josehu.com/assets/dev-env/emailme.zsh -O ~/.local/bin/emailme
chmod a+x ~/.local/bin/emailme

# auto tmux (last step, not recommended)
# section_header "auto-tmux"
# echo "Last step: auto start tmux on login in '.zshrc'..."
# append_to_file .zshrc ""
# append_to_file .zshrc "# auto tmux (keep at the bottom of .zshrc)"
# append_to_file .zshrc "test -z \"\$TMUX\" && (tmux attach || tmux new-session)"
