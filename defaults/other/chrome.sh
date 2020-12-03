#!/usr/bin/env bash

PREFS=~/Library/Application\ Support/Google/Chrome/Default/Preferences
TMP_PREFS=/tmp/ChromePreferences
TMP_PREFS2=/tmp/ChromePreferences2
cp "$PREFS" $TMP_PREFS

if [[ ! -s $PREFS ]]; then
  echo "Preferences is empty or missing."
  exit
fi

TIMESTAMP=$(python2 - <<END
from datetime import datetime

def calculateTimestamp():
    epoch = datetime(1601, 1, 1)
    utcnow = datetime.strptime(datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f'), '%Y-%m-%d %H:%M:%S.%f')
    diff = utcnow - epoch
    secondsInDay = 60 * 60 * 24
    return '{}{:06d}'.format(diff.days * secondsInDay + diff.seconds, diff.microseconds)
print calculateTimestamp()
END
)

# Handlers (chrome://settings/handlers?search=handlers)
HAS_CUSTOM_HANDLERS=`cat "$PREFS" | jq '.custom_handlers'`
if [ "$HAS_CUSTOM_HANDLERS" == "null" ]; then
  echo "Adding custom_handlers object"
  jq '. + {"custom_handlers": {"enabled": true, "ignored_protocol_handlers": [], "registered_protocol_handlers": []}}' $TMP_PREFS > $TMP_PREFS2
  cp $TMP_PREFS2 $TMP_PREFS
  cp $TMP_PREFS "$PREFS"
fi

HAS_MAILTO=`cat "$PREFS" | jq '.custom_handlers.registered_protocol_handlers' | jq 'contains([{"protocol": "mailto"}])'`
if [ $HAS_MAILTO != "true" ]; then
  MAILTO=$(cat <<END
  {
    "default": true,
    "last_modified": "$TIMESTAMP",
    "protocol": "mailto",
    "url": "https://mail.google.com/mail/?extsrc=mailto&url=%s"
  }
END
)
  echo "Adding mailto handler"
  jq --argjson handler "$MAILTO" '.custom_handlers.registered_protocol_handlers |= . + [$handler]' $TMP_PREFS > $TMP_PREFS2
  cp $TMP_PREFS2 $TMP_PREFS
fi

HAS_WEBCAL=`cat "$PREFS" | jq '.custom_handlers.registered_protocol_handlers' | jq 'contains([{"protocol": "webcal"}])'`
if [ $HAS_WEBCAL != "true" ]; then
  WEBCAL=$(cat <<END
  {
    "default": true,
    "last_modified": "$TIMESTAMP",
    "protocol": "webcal",
    "url": "https://calendar.google.com/calendar/r?cid=%s"
  }
END
)
  echo "Adding webcal handler"
  jq --argjson handler "$WEBCAL" '.custom_handlers.registered_protocol_handlers |= . + [$handler]' $TMP_PREFS > $TMP_PREFS2
  cp $TMP_PREFS2 $TMP_PREFS
fi

# Toolbar
jq .extensions.toolbarsize=6 $TMP_PREFS > $TMP_PREFS2
cp $TMP_PREFS2 $TMP_PREFS

# Disable site notifications
jq '.profile += {"default_content_setting_values": {"notifications": 2}}' $TMP_PREFS > $TMP_PREFS2
cp $TMP_PREFS2 $TMP_PREFS

# Set DevTools Dock position
jq '.devtools.preferences.currentDockState = "\"bottom\""' $TMP_PREFS > $TMP_PREFS2
cp $TMP_PREFS2 $TMP_PREFS

cp $TMP_PREFS "$PREFS"
