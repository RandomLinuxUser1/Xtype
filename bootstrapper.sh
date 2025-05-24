#!/bin/bash

REPO="https://github.com/RandomLinuxUser1/Xtype.git"
TMP_DIR=$(mktemp -d)
INSTALL_DIR="$HOME/Xtype"

cleanup() {
    rm -rf "$TMP_DIR"
    [ -f "$HOME/xtype_updater_backup.sh" ] && rm "$HOME/xtype_updater_backup.sh"
}

trap cleanup EXIT

if ! git clone --quiet "$REPO" "$TMP_DIR" 2>/dev/null; then
    exit 1
fi

if [ ! -f "$TMP_DIR/Version.txt" ]; then
    exit 1
fi

current_ver=0
[ -f "$INSTALL_DIR/Version.txt" ] && current_ver=$(cat "$INSTALL_DIR/Version.txt")
new_ver=$(cat "$TMP_DIR/Version.txt")

if [ "$new_ver" -gt "$current_ver" ] || [ ! -d "$INSTALL_DIR" ]; then
    cp "$0" "$HOME/" || exit 1
    [ -f "/usr/local/bin/xtype" ] && sudo rm /usr/local/bin/xtype ~/.xtype_stats 2>/dev/null
    rm -rf "$INSTALL_DIR"
    mv "$TMP_DIR" "$INSTALL_DIR" || exit 1
    chmod +x "$INSTALL_DIR/game.bash" || exit 1
    find ~ -name "game.bash" -exec sudo ln -sf {} /usr/local/bin/xtype \; -exec chmod +x {} \; -quit
    exec "$INSTALL_DIR/game.bash"
fi

exit 0
