#!/bin/bash

source "$(dirname $0)/support.sh"
source "$(dirname $0)/support.git.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    clobber $filename
    clobber $peopleFilename

    tempDir=$(newTemporaryGitRepository)

    SKIP_DOWNLOAD=1 bash install.sh
    
    source xp-mode.sh

    cd $tempDir > /dev/null
}

function after_each {
    cd - >> /dev/null

    debug "Deleting <$tempDir>"; rm -r $tempDir

    debug "Current directory is now <$(pwd)>"
}

test "it makes a hook file and it has the #xp-mode tag in it"

  pair hooks

  fileMustExist "$tempDir/.git/hooks/commit-msg"

  fileMustContain "#xp-mode" "$tempDir/.git/hooks/commit-msg"
  
  after_each

test "it skips if it one is already present"

  touch "$tempDir/.git/hooks/commit-msg"

  result=$(pair hooks)

  mustMatch "You already have a commit-msg hook" "$result"
  
  after_each

test "use the \`hooks -d\` command to remove hooks"

  pair hooks

  pair hooks -d

  fileMustNotExist "$tempDir/.git/hooks/commit-msg"

  after_each

test "only deletes the hook if it is ours"

  touch "$tempDir/.git/hooks/commit-msg"

  pair hooks -d

  fileMustExist "$tempDir/.git/hooks/commit-msg"

  after_each

test "it skips if the hook file does not exist"

  clobber "$tempDir/.git/hooks/commit-msg"

  result=$(pair hooks -d)

  mustMatch "nothing to delete" "$result"

  after_each
  
