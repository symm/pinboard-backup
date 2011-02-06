#!/bin/bash
# Performs version controlled backup of your http://pinboard.in/ bookmarks
SRC="https://pinboard.in/export/"
DEST=$HOME"/.pinboard/"
USERAGENT="Mozilla/5.0"
TAG="Pinboard"

if [ ! -d "$DEST" ]; then
  git init -q $DEST
fi

curl -s -A $USERAGENT --netrc $SRC -o $DEST"pinboard.xml"
if [ $? != 0 ]; then
  logger -p 3 -t "$TAG" "Unable to fetch bookmarks export"
  exit 1
fi

cd $DEST
git add pinboard.xml
git commit -q -m "Pinboard cron backup" &> /dev/null
RESPONSE=$?
if [ $RESPONSE == 0 ]; then
  logger -t "$TAG" "Pinboard backup success"
fi
if [ $RESPONSE == 1 ]; then
  logger -t "$TAG" "Nothing new to backup"
fi
