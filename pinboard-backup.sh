#!/bin/bash
# https://github.com/symm/pinboard-backup
# Performs version controlled backup of your http://pinboard.in/ bookmarks

SRC="https://pinboard.in/export/"
DEST=$HOME"/.pinboard/"
USERAGENT="PinboardBackup +https://github.com/symm/pinboard-backup"
VALID_TYPE="exported SGML document text"

if [ ! -d "$DEST" ]; then
  echo "Initial run, creating a new Git repo in $DEST"
  git init -q $DEST
fi

curl -s -A "$USERAGENT" --netrc $SRC -o $DEST"pinboard.html"
if [ $? != 0 ]; then
  echo "[!] Unable to fetch the export. Your latest bookmarks were NOT saved."
  exit 1
fi

cd $DEST
EXPORT_TYPE=`file -b pinboard.html`
if [ "$EXPORT_TYPE" != "$VALID_TYPE" ]; then
  echo "[!] Unable to save your latest bookmarks. The downloaded file was not \"$VALID_TYPE\". " 
  git checkout HEAD . &> /dev/null
  exit 1
fi
git add pinboard.html &> /dev/null
git commit -q -m "Pinboard cron backup" &> /dev/null

RESPONSE=$?
if [ $RESPONSE == 0 ]; then
  echo "Your latest Pinboard bookmarks have been saved"
fi
if [ $RESPONSE == 1 ]; then
  echo "Your Pinboard backup is already up-to-date"
fi
