#!/bin/bash
#
# Multiple Git Sync/lone 
#
# Given a directory on a remote machine, will clone each directory inside 
# given the sub-directory is a git repository.
#
# By Eddie Blundell eblundell@gmail.com
# 22/12/2012
#
# Use at your own risk!

# TODO: Allow server and directory to be overridden by arguments
# TODO: More extensive git testing, not just .git extension

SSH_SERVER="eddie@80.77.87.232"
SSH_PORT="22"

DIRECTORY="/srv/git/"
CLONE_DEST=${1:-$PWD}

DIRECTORIES=$(ssh -T -P$SSH_PORT $SSH_SERVER "find $DIRECTORY*.git -maxdepth 0")

mkdir -p $CLONE_DEST
cd $CLONE_DEST

for d in $DIRECTORIES
do
  git clone "$SSH_SERVER:$d" > /dev/null
  echo "Cloning $SSH_SERVER:$d into $CLONE_DEST"
done

