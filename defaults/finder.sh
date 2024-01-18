#!/usr/bin/env bash

PLIST=~/Library/Preferences/com.apple.finder.plist
APP=/Applications/Go2Shell.app/Contents/MacOS/Go2ShellHelper.app

/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser':'TB Item Identifiers'" $PLIST

/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers' array" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':0 string com.apple.finder.BACK" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':1 string NSToolbarFlexibleSpaceItem" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':2 string com.apple.finder.SWCH" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':3 string com.apple.finder.ARNG" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':4 string com.apple.finder.NFLD" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':5 string NSToolbarFlexibleSpaceItem" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':6 string com.apple.finder.SRCH" $PLIST

/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Plists:7:_CFURLString' string 'file://$APP'" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Plists:7:_CFURLStringType' integer 15" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers:7' string 'com.apple.finder.loc '" $PLIST

killall -HUP Finder
