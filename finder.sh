#!/usr/bin/env bash

PLIST=~/Library/Preferences/com.apple.finder.plist
ITEMS=`/usr/libexec/PlistBuddy -c "Print 'NSToolbar Configuration Browser:TB Default Item Identifiers'" $PLIST | sed '1d; $d'`
APP=/Applications/Go2Shell.app/Contents/MacOS/Go2ShellHelper.app/
POSITION=8

/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser:TB Item Identifiers'" $PLIST
/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser:TB Item Plists'" $PLIST 2>/dev/null

/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers' array" $PLIST
i=1
for ITEM in $ITEMS
do
  if [ $i -ne $POSITION ]; then
    /usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers:$i' string $ITEM" $PLIST
  fi
  ((i++))
done

/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Plists:$POSITION:_CFURLString' string 'file://$APP'" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Plists:$POSITION:_CFURLStringType' integer 15" $PLIST
#/usr/libexec/PlistBuddy -c "Import 'NSToolbar Configuration Browser:TB Item Plists:$POSITION:_CFURLAliasData' alias_data" $PLIST
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers:$POSITION' string 'com.apple.finder.loc '" $PLIST

killall -HUP Finder
