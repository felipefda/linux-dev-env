#!/usr/bin/env bash

source ./env.conf

set -v
set -e

#tar -xvzf sqldeveloper/sqldeveloper.tar.gz -C $appspath
cat > ~/.local/share/applications/sqldeveloper.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=SqlDeveloper
Icon=$appspath/sqldev/icon.png
Exec="$appspath/sqldev/sqldeveloper.sh" %f
Comment=Capable and Ergonomic IDE for JVM
Terminal=false
EOL