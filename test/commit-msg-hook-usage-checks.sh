#!/bin/bash

source "$(dirname $0)/support.sh"
source "$(dirname $0)/support.git.sh"

function before_each {
    git config --global user.name "Ben"
    git config --global user.email "ben@gmail.com"

    tempDir=$(newTemporaryGitRepository)

    SKIP_DOWNLOAD=1 bash install.sh
    
    source xp-mode.sh

    clobber $peopleFilename;

    echo "Alan; alan@gmail.com"                   >> $peopleFilename
    echo "Darren; darren@gmail.com"               >> $peopleFilename
    echo "Wanda; wanda@gmail.com"                 >> $peopleFilename
    
    cd $tempDir
}

function after_each {
    cd -

    debug "Deleting <$tempDir>"; rm -rf $tempDir

    debug "Current directory is now <$(pwd)>"
}

test 'it adds `Co-authored-by` trailers to your commit'

  pair hooks

  pair Darren,Wanda
  
  commit "Push to master"
  
  expected="Push to master

Co-authored-by: Mob <darren@gmail.com>
Co-authored-by: Mob <wanda@gmail.com>
Co-authored-by: Ben <ben@gmail.com>"

  lastCommitMessageMustBe "$expected"
  
  after_each

test 'it adds full name instead of "Mob" if there is one'

  echo "Lisa; Lisa Shickadance; lisa@gmail.com" >> $peopleFilename

  pair hooks

  pair Darren,Lisa,Wanda
  
  commit "Push to master"
  
  expected="Push to master

Co-authored-by: Mob <darren@gmail.com>
Co-authored-by: Lisa Shickadance <lisa@gmail.com>
Co-authored-by: Mob <wanda@gmail.com>
Co-authored-by: Ben <ben@gmail.com>"

  lastCommitMessageMustBe "$expected"
  
  after_each

test 'it does not add `Co-authored-by` when no pair has been set'

  $(pair hooks)

  clobber "$HOME/.xp-mode/current"

  commit "Push to master"

  lastCommitMessageMustBe "Push to master"

  after_each

test 'it does not add `Co-authored-by` when \`current\` file is empty'

  $(pair hooks)

  clobber "$HOME/.xp-mode/current"; touch "$HOME/.xp-mode/current"

  commit "Push to master"

  lastCommitMessageMustBe "Push to master"

  after_each
