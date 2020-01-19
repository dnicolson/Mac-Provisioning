#!/usr/bin/env bash

cd /tmp
git clone git@github.com:dnicolson/dbx-keygen-macos.git
cd dbx-keygen-macos
pip2 install crypto pycrypto simplejson pbkdf2
KEY=`python2 dbx-keygen-macos.py | tr '\n' '\r' | sed -e 's/.*Database key:  \(.*\)./\1/g'`

cd ..
git clone git@github.com:dnicolson/sqlite3-dbx.git
cd sqlite3-dbx
gcc -o sqlite3 -I. -DSQLITE_HAS_CODEC -DHAVE_READLINE shell.c sqlite3.c -Wall -ggdb -ldl -lpthread -lreadline -lncurses

# The following defaults will be set:
# - Disable sharing screenshots
# - Disable camera uploads
# - Remove the Chrome extension notification
# - Disable the move out of Dropbox warning
# - Disable the move to trash warning

./sqlite3 -key $KEY ~/.dropbox/instance1/config.dbx <<END
INSERT INTO config (key, value) VALUES ('save_screenshots', 0);
INSERT INTO config (key, value) VALUES ('photo_import', 0);
INSERT INTO config (key, value) VALUES ('chrome-extension-notif-seen', 1);
INSERT INTO config (key, value) VALUES ('RestorationRule', X'80027D7100580500000072756C6532710188732E');
INSERT INTO config (key, value) VALUES ('FSWSuppressionSettings', X'80027D710028580E000000726573746F726174696F6E735F327101885821000000726573746F726174696F6E735F315F616E645F335F696E61636365737369626C65710288752E');
UPDATE config SET value=0 WHERE key='save_screenshots';
UPDATE config SET value=0 WHERE key='photo_import';
UPDATE config SET value=1 WHERE key='chrome-extension-notif-seen';
UPDATE config SET value=X'80027D7100580500000072756C6532710188732E' WHERE key='RestorationRule';
UPDATE config SET value=X'80027D710028580E000000726573746F726174696F6E735F327101885821000000726573746F726174696F6E735F315F616E645F335F696E61636365737369626C65710288752E' WHERE key='FSWSuppressionSettings';
END

cd ..
rm -rf dbx-keygen-macos sqlite3-dbx
