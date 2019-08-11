#!/usr/bin/env bash

source ./env.conf

set -v
set -e

sudo apt-get install -y software-properties-common wget curl jq vim


cd ~/Downloads
    curl -s "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release" > idea.json
    LATEST_IDEA=`cat idea.json | jq -r '.IIC[0].downloads.linux.link'`
    MAJOR_VERSION=`cat idea.json | jq -r '.IIC[0].majorVersion'`
    CONFIG_FOLDER=~/.IdeaIC$MAJOR_VERSION/config
    wget -O idea.tar.gz $LATEST_IDEA
    tar -xzf idea.tar.gz
    mv idea-IC-* $appspath/idea
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
Icon=$appspath/idea/bin/idea.png
Exec="$appspath/idea/bin/idea.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea-ce
EOL