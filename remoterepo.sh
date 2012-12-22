#!/bin/bash
#
# Remote GIT Initializer 
#
# By Eddie eblundell@gmail.com
# 21/12/2012 
# 
# Use at your own risk!
#

# TODO: Check if remote already exists
# TODO: Allow confirmation mode, most accept or overide with -f to continue
# TODO: Allow silent mode and full verbose mode

FOLDER_PATH=$1
FOLDER_NAME=${FOLDER_PATH##*/}

SSH_SERVER="eddie@80.77.87.232"
SSH_PORT="22"

GIT_ROOT="/srv/git/"
GIT_PATH="$GIT_ROOT$FOLDER_NAME.git"

REMOTE_NAME="vps"

# Create the new repository if it doesnt exist
mkdir -p "$1"
cd $1

# Create a repo on the server

echo -e "Connecting to remote server..."

ssh -T -P"$SSH_PORT" "$SSH_SERVER" <<ENDSSH

  if [ ! -d "$GIT_PATH" ]
  then
    echo -e "Initializing remote repository..."
    mkdir -p $GIT_PATH
    cd $GIT_PATH
    git --bare init
  fi
ENDSSH

echo -e "Initializing local repository..."

if find . -maxdepth 0 -empty | read; 
then
  touch README
fi

if  [ ! -d ".git" ]; then
  git init .
  git add . > /dev/null
  git commit -m "first commit" > /dev/null
fi

echo -e "Syncing files..."

# Finally do a first sync
git remote add "$REMOTE_NAME" "$SSH_SERVER:$GIT_PATH" > /dev/null 2>&1
git push --set-upstream "$REMOTE_NAME" master > /dev/null 2>&1
