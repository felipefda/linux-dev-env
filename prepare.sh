#! /bin/bash

#Load config file
source ./env.conf

#update distro
sudo apt update && sudo apt upgrade -y

#install some util packages
sudo apt install -y curl git zsh timeshift transmission-cli gufw ttf-mscorefonts-installer 
nnn ddgr ttf-fira-code chromium-browser vim unzip xclip transmission-gtk telegram-desktop catfish papirus-icon-theme

#enable and install snap packages
sudo snap install spotify --classic
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install simplenote signal-desktop

#install hyper
wget https://hyper-updates.now.sh/download/linux_deb
sudo dpkg -i linux_deb
rm linux_deb

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
npm install --global fkill-cli internal-ip-cli is-online-cli is-up-cli public-ip-cli realpath vtop wikit trash-cli empty-trash-cli wifi-password-cli tldr
fi

#install maven
sudo apt install -y maven

#export java
export JAVA_HOME="/data/jdk8"
export PATH=$JAVA_HOME/bin:$PATH

#idea
curl -s "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release" > idea.json
    LATEST_IDEA=`cat idea.json | jq -r '.IIC[0].downloads.linux.link'`
    MAJOR_VERSION=`cat idea.json | jq -r '.IIC[0].majorVersion'`
    CONFIG_FOLDER=~/.IdeaIC$MAJOR_VERSION/config
    wget -O idea.tar.gz $LATEST_IDEA
    tar -xzf idea.tar.gz
    mv idea-IC-* ~/dev/idea
    mkdir -p $CONFIG_FOLDER/keymaps
    curl -s "https://prerequisites.pal.pivotal.io/prerequisites/prerequisites/linux-install/XWinImproved.xml" > $CONFIG_FOLDER/keymaps/XWinImproved.xml

    mkdir -p $CONFIG_FOLDER/options
    cat > ~/.IdeaIC$MAJOR_VERSION/config/options/keymap.xml <<EOL
<application>
  <component name="KeymapManager">
    <active_keymap name="XWin Improved" />
  </component>
</application>
EOL

cat > ~/.local/share/applications/jetbrains-idea-ce.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Community Edition
Icon=$HOME/dev/idea/bin/idea.png
Exec="$HOME/dev/idea/bin/idea.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea-ce
EOL

#postman
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
tar -xzf postman.tar.gz -C $rootpath/apps
rm postman.tar.gz
cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=Postman
Icon=/usr/share/icons/Papirus/48x48/apps/postman.svg
Exec="$rootpath/apps/postman/app/Postman" %f
Comment=Capable and Ergonomic IDE for JVM
Terminal=false
EOL

#ojdbc7
if test $inst_ojdbc = 1
then
mvn install:install-file -Dfile=ojdbc/ojdbc7.jar -DgroupId=com.oracle  -DartifactId=ojdbc7 -Dversion=12.1.0 -Dpackaging=jar
fi

#weblogic
if test $inst_weblogic = 1
then
tar -xvzf oracle/oracle_home.tar.gz -C $rootpath
cd $rootpath/Oracle_Home/oracle_common/plugins/maven/com/oracle/maven/oracle-maven-sync/12.2.1
mvn install:install-file -DpomFile=oracle-maven-sync-12.2.1.pom -Dfile=oracle-maven-sync-12.2.1.jar
mvn com.oracle.maven:oracle-maven-sync:push -DoracleHome=$rootpath/Oracle_Home/.

fi

#dotnet sdk
if test $inst_dotnetsdk = 1
then
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2
rm packages-microsoft-prod.deb
fi

#sqldeveloper
if teste $inst_sqldeveloper = 1
then
tar -xvzf sqldeveloper/sqldeveloper.tar.gz -C $rootpath/apps
cat > ~/.local/share/applications/sqldeveloper.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=SqlDeveloper
Icon=$rootpath/apps/sqldev/icon.png
Exec="$rootpath/apps/sqldev/sqldeveloper.sh" %f
Comment=Capable and Ergonomic IDE for JVM
Terminal=false
EOL

fi

sudo apt install -y -f

#default apps

gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'thunderbird.desktop', 'hyper.desktop','org.gnome.Nautilus.desktop', 'jetbrains-idea-ce.desktop','code_code.desktop','chromium-browser.desktop','skype_skypeforlinux.desktop','slack_slack.desktop','spotify_spotify.desktop',]"

#zsh default
chsh -s $(which zsh)
