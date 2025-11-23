#!/usr/bin/env bash

PLIST="$HOME/Library/Preferences/com.apple.finder.plist"
APP="/Applications/OpenInTerminal-Lite.app"
POSITION=$(( $(/usr/libexec/PlistBuddy -c "Print 'NSToolbar Configuration Browser:TB Item Identifiers'" "$PLIST" | wc -l | tr -d ' ') - 2 ))

/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Plists:$POSITION:_CFURLString' string 'file://$APP'" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Plists:$POSITION:_CFURLStringType' integer 15" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers:$POSITION' string 'com.apple.finder.loc '" $PLIST

killall -HUP Finder
