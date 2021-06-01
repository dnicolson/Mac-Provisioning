#!/usr/bin/env bash

cd /tmp
git clone https://github.com/dnicolson/dbx-keygen-macos.git
cd dbx-keygen-macos
pip2 install crypto pycrypto simplejson pbkdf2
KEY=`python2 dbx-keygen-macos.py | tr '\n' '\r' | sed -e 's/.*Database key:  \(.*\)./\1/g'`

cd ..
git clone https://github.com/dnicolson/sqlite3-dbx.git
cd sqlite3-dbx
gcc -o sqlite3 -I. -DSQLITE_HAS_CODEC -DHAVE_READLINE shell.c sqlite3.c -Wall -ggdb -ldl -lpthread -lreadline -lncurses

# The following defaults will be set:
# - Disable sharing screenshots
# - Disable camera uploads
# - Disable the Chrome extension notification
# - Disable the move out of Dropbox warning
# - Disable the move to trash warning
# - Disable the get notified about important activity notification

./sqlite3 -key $KEY ~/.dropbox/instance1/config.dbx <<END
INSERT OR IGNORE INTO config (key, value) VALUES ('save_screenshots', 0);
INSERT OR IGNORE INTO config (key, value) VALUES ('photo_import', 0);
INSERT OR IGNORE INTO config (key, value) VALUES ('chrome-extension-notif-seen', 1);
INSERT OR IGNORE INTO config (key, value) VALUES ('RestorationRule', X'80027D7100580500000072756C6532710188732E');
INSERT OR IGNORE INTO config (key, value) VALUES ('FSWSuppressionSettings', X'80027D710028580E000000726573746F726174696F6E735F327101885821000000726573746F726174696F6E735F315F616E645F335F696E61636365737369626C65710288752E');
INSERT OR IGNORE INTO config (key, value) VALUES ('mac_notifications_authorization_sticky_dismissed', 1);
UPDATE config SET value=0 WHERE key='save_screenshots';
UPDATE config SET value=0 WHERE key='photo_import';
UPDATE config SET value=1 WHERE key='chrome-extension-notif-seen';
UPDATE config SET value=X'80027D7100580500000072756C6532710188732E' WHERE key='RestorationRule';
UPDATE config SET value=X'80027D710028580E000000726573746F726174696F6E735F327101885821000000726573746F726174696F6E735F315F616E645F335F696E61636365737369626C65710288752E' WHERE key='FSWSuppressionSettings';
UPDATE config SET value=1 WHERE key='mac_notifications_authorization_sticky_dismissed';
END

cd ..
rm -rf dbx-keygen-macos sqlite3-dbx
