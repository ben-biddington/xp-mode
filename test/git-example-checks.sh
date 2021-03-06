#!/bin/bash

source "$(dirname $0)/support.sh"
source "$(dirname $0)/support.git.sh"

function before_each {
    git config --global user.name "Ben Biddington"
    git config --global user.email "ben@gmail.com"

    tempDir=$(newTemporaryGitRepository)
    
    SKIP_DOWNLOAD=1 bash install.sh
    
    source xp-mode.sh

    clobber $peopleFilename;

    echo "Ben; ben@gmail.com"      >> $peopleFilename
    echo "Lisa; lisa@gmail.com"    >> $peopleFilename
    echo "Denny; denny@gmail.com"  >> $peopleFilename

    cd $tempDir
}

function after_each {
    cd -

    debug "Deleting <$tempDir>"; rm -rf $tempDir

    debug "Current directory is now <$(pwd)>"
}

test "it sets author and commiter"

  pair Ben,Richard,Denny
  
  commit "Push to master"
  
  expected="
Author: Ben, Lisa and Denny <denny@gmail.com>
Commit: Ben <ben@gmail.com>

    Push to master

"

  lastCommitMustContain "$expected"
  
  after_each

test "it adds Co-authored-by trailers when hooks are enabled"

  pair hooks

  pair Ben,Lisa,Denny
  
  commit "And use small batches"
  
  expected="
Author: Ben, Lisa and Denny <denny@gmail.com>
Commit: Ben <ben@gmail.com>

    And use small batches

    Co-authored-by: Mob <ben@gmail.com>
    Co-authored-by: Mob <lisa@gmail.com>
    Co-authored-by: Mob <denny@gmail.com>
"

  lastCommitMustContain "$expected"
  
  after_each

