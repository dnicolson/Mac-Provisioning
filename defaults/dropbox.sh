#!/usr/bin/env bash

cd /tmp
git clone https://github.com/dnicolson/dbx-keygen-macos.git
cd dbx-keygen-macos
pip2 install pyyaml==5.3.1 crypto pycrypto simplejson pbkdf2
KEY=`python2 dbx-keygen-macos.py | tr '\n' '\r' | sed -e 's/.*Database key:  \(.*\)./\1/g'`

cd ..
git clone https://github.com/dnicolson/sqlite3-dbx.git
cd sqlite3-dbx
gcc -o sqlite3 -I. -DSQLITE_HAS_CODEC -DHAVE_READLINE shell.c sqlite3.c -Wall -ggdb -ldl -lpthread -lreadline -lncurses

# The following defaults will be set:
# - Disable sharing screenshots
# - Disable camera uploads
# - Disable the Chrome extension notification
# - Disable the get notified about important activity notification
# - Disable "Keep your Mac files backed up." notification
# - Uncheck "Show setup notifications when new external drives are plugged-in"
# - Disable "Keep your Mac files backed up."

# SELECT key, QUOTE(value) FROM config;

./sqlite3 -key $KEY $(ls ~/.dropbox/instance[0-9]*/config.dbx) <<END
INSERT OR IGNORE INTO config (key, value) VALUES ('save_screenshots', 0);
INSERT OR IGNORE INTO config (key, value) VALUES ('photo_import', 0);
INSERT OR IGNORE INTO config (key, value) VALUES ('chrome-extension-notif-seen', 1);
INSERT OR IGNORE INTO config (key, value) VALUES ('mac_notifications_authorization_sticky_dismissed', 1);
INSERT OR IGNORE INTO config (key, value) VALUES ('desktop-sync-everything-sticky-dismissed', 1);
INSERT OR IGNORE INTO config (key, value) VALUES ('desktop-edb-pref-suppressed', 1);
INSERT OR IGNORE INTO config (key, value) VALUES ('desktop-sync-everything-sticky-dismissed', 1);
UPDATE config SET value=0 WHERE key='save_screenshots';
UPDATE config SET value=0 WHERE key='photo_import';
UPDATE config SET value=1 WHERE key='chrome-extension-notif-seen';
UPDATE config SET value=1 WHERE key='mac_notifications_authorization_sticky_dismissed';
UPDATE config SET value=1 WHERE key='desktop-sync-everything-sticky-dismissed';
UPDATE config SET value=1 WHERE key='desktop-edb-pref-suppressed';
UPDATE config SET value=1 WHERE key='desktop-sync-everything-sticky-dismissed';
END

cd ..
rm -rf dbx-keygen-macos sqlite3-dbx

killall Dropbox
sleep 10
open -a Dropbox