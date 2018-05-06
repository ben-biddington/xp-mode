#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "Ben"
    git config --global user.email "ben@gmail.com"

    tempDir=`mktemp -d -p "$DIR"`

    SKIP_DOWNLOAD=1 bash install.sh
    
    source xp-mode.sh

    clobber $peopleFilename;

    echo "Alan; alan@gmail.com"     >> $peopleFilename
    echo "Darren; darren@gmail.com" >> $peopleFilename
    echo "Wanda; wanda@gmail.com"   >> $peopleFilename
    
    cd $tempDir

    git init
}

function after_each {
    cd -

    debug "Deleting <$tempDir>"; rm -rf $tempDir

    debug "Current directory is now <$(pwd)>"
}

test "it adds a message to your commit"

  $(pair hooks)

  pair Darren,Wanda

  echo "No forks please" >> README.md

  git add README.md
  git commit -am "Push to master"

  theCommitMessage="$(git log --format=%B -n 1)"

  expected="Push to master

Co-authored-by: <darren@gmail.com>
Co-authored-by: <wanda@gmail.com>"
  mustBe "$expected" "$theCommitMessage"
  
  after_each

test "it does not add message when no pair has been set"

  $(pair hooks)

  rm "$HOME/.xp-mode/current"

  echo "No forks please" >> README.md

  git add README.md 
  git commit -am "Push to master"

  theCommitMessage="$(git log --format=%B -n 1)"

  mustBe "Push to master" "$theCommitMessage"

  after_each

  pending "Same when current file is empty"
