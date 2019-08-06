#! /bin/bash

#Load config file
source ./env.conf

#update distro
sudo apt update && sudo apt upgrade -y

#install some util packages
sudo apt install -y curl git zsh timeshift transmission-cli gufw ttf-mscorefonts-installer 
nnn ddgr ttf-fira-code chromium-browser vim unzip xclip transmission-gtk

#zsh default
chsh -s $(which zsh)

#enable and install snap packages
sudo snap install spotify code --classic

#code files
mkdir -p ~/.config/Code/User/
cp code/settings.json .config/Code/User/settings.json
cp code/keybindings.json .config/Code/User/keybindings.json

#ssh files
cp ssh/* ~/.ssh/
chmod 600 ~/.ssh/id_rsa 
chmod 600 ~/.ssh/id_rsa.pub 
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

#move wallpaper
cp wallpaper.jpg ~/Pictures/

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


if test $inst_nodelts = 1
then
#install node with nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#node
nvm install --lts

#node cli packages
npm install --global fkill-cli internal-ip-cli is-online-cli is-up-cli public-ip-cli realpath vtop wikit trash-cli empty-trash-cli wifi-password-cli tldr
fi

#install maven
sudo apt install -y maven

#export java
export JAVA_HOME="/data/jdk8"
export PATH=$JAVA_HOME/bin:$PATH

#ojdbc7
if test $inst_ojdbc = 1
then
mvn install:install-file -Dfile=ojdbc/ojdbc7.jar -DgroupId=com.oracle  -DartifactId=ojdbc7 -Dversion=12.1.0 -Dpackaging=jar
fi

#weblogic
if test $inst_weblogic = 1
then
cp oracle_home.tar.gz /data/.
tar -xvzf jdk/jdk8.tar.gz -C $rootpath
cd $rootpath/Oracle_Home/oracle_common/plugins/maven/com/oracle/maven/oracle-maven-sync/12.2.1
mvn install:install-file -DpomFile=oracle-maven-sync-12.2.1.pom -Dfile=oracle-maven-sync-12.2.1.jar
mvn com.oracle.maven:oracle-maven-sync:push -DoracleHome=$rootpath/Oracle_Home/.

fi