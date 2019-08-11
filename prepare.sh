#! /bin/bash

#Load config file
source ./env.conf

#update distro
sudo apt update && sudo apt upgrade -y

#install some util packages
sudo apt install -y curl git zsh timeshift transmission-cli gufw ttf-mscorefonts-installer nnn ddgr fonts-firacode chromium-browser vim unzip xclip transmission-gtk telegram-desktop catfish papirus-icon-theme gnome-tweaks

#enable and install snap packages
sudo snap install spotify --classic
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install skype --classic
sudo snap install simplenote signal-desktop

#install hyper
./installhyper.sh

#code files
mkdir -p ~/.config/Code/User/
cp code/settings.json ~/.config/Code/User/settings.json
cp code/keybindings.json ~/.config/Code/User/keybindings.json

#move and set wallpaper
cp wallpaper.jpg ~/Pictures/
gsettings set org.gnome.desktop.background picture-uri $HOME/Pictures/wallpaper.jpg

#oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#pure
mkdir ~/.zfunctions
cp pure/prompt_pure_setup ~/.zfunctions
cp pure/async ~/.zfunctions

#extract and move jdk8
tar -xvzf jdk/jdk8.tar.gz -C $rootpath

#vimrc
cp vim/.vimrc ~

#zshrc
cp zsh/.zshrc ~

# set some basic git config settings
git config --global core.editor vim
git config --global user.name $git_name
git config --global user.email $git_email

#create apps dir
mkdir -p $rootpath/apps

if test $inst_nodelts = 1
then
#install node with nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#node
nvm install --lts
fi

#node cli packages
if test $inst_nodeclipkg =1
then
npm install --global fkill-cli internal-ip-cli is-online-cli is-up-cli public-ip-cli realpath vtop wikit trash-cli empty-trash-cli wifi-password-cli tldr @angular/cli
fi

#install maven
sudo apt install -y maven

#idea
./installidea.sh

#postman
./installpostman.sh

#ojdbc7
if test $inst_ojdbc = 1
then
mvn install:install-file -Dfile=ojdbc/ojdbc7.jar -DgroupId=com.oracle  -DartifactId=ojdbc7 -Dversion=12.1.0 -Dpackaging=jar
fi

#weblogic
if test $inst_weblogic = 1
then
./installweblogic.sh
fi

#dotnet sdk
if test $inst_dotnetsdk = 1
then
./installdotnetsdk.sh
fi

#sqldeveloper
if teste $inst_sqldeveloper = 1
then
./installsqldeveloper.sh
fi

sudo apt install -y -f

#default apps

gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'thunderbird.desktop', 'hyper.desktop','org.gnome.Nautilus.desktop', 'jetbrains-idea-ce.desktop','code_code.desktop','chromium-browser.desktop','skype_skypeforlinux.desktop','slack_slack.desktop','spotify_spotify.desktop']"

#zsh default
chsh -s $(which zsh)
