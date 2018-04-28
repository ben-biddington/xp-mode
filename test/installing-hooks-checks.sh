#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    clobber $filename
    clobber $peopleFilename

    tempDir=`mktemp -d -p "$DIR"`

    SKIP_DOWNLOAD=1 bash install.sh
    
    source xp-mode.sh
    
    cd $tempDir

    git init
}

function after_each {
    cd -

    debug "Deleting <$tempDir>"; rm -r $tempDir

    debug "Current directory is now <$(pwd)>"
}

test "it makes a hook file"
  pair hooks

  fileMustExist "$tempDir/.git/hooks/pre-commit"

  after_each
