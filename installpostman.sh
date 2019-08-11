#!/usr/bin/env bash

source ./env.conf

set -v
set -e

cd ~/Downloads
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
tar -xzf postman.tar.gz -C $appspath/
rm postman.tar.gz
cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=Postman
Icon=/usr/share/icons/Papirus/48x48/apps/postman.svg
Exec="$appspath/Postman/Postman" %f
Terminal=false
EOL