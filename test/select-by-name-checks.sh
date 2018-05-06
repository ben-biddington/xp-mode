#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    clobber $peopleFilename
    
    git config --global user.name "Ben Biddington"
    git config --global user.email "ben@gmail.com"

    SKIP_DOWNLOAD=1 bash install.sh; source xp-mode.sh
    
    echo "Ben; ben@gmail.com" >> $peopleFilename
    echo "Denny; denny@gmail.com" >> $peopleFilename
    echo "Mark; mark@gmail.com" >> $peopleFilename
    echo "Lisa; lisa@gmail.com" >> $peopleFilename
}

test "select a pair by using names"

  pair "Ben,Denny,Lisa"

  gitAuthorMustEqual "Ben, Denny, Lisa" "lisa@gmail.com"

test "it just uses the names you supply" # Could use the current configured user.nane, but that often is full name
  
  pair "Lisa"

  gitAuthorMustEqual "Lisa" "lisa@gmail.com"

test "it uses the email address for the last person in the list"

  pair "Ben,Lisa,Denny"

  gitAuthorMustEqual "Ben, Lisa, Denny" "denny@gmail.com"

  pair "Ben,Lisa,Mark"

  gitAuthorMustEqual "Ben, Lisa, Mark" "mark@gmail.com"
  
test "it fails when name is not recognised"

  result=`pair "Malcolm"`

  mustMatch "Unknown person" "$result"

test "records email addresses in a file"

  pair Denny,Mark,Lisa

  expected="denny@gmail.com\nmark@gmail.com\nlisa@gmail.com"

  fileMustExist "$HOME/.xp-mode/current"

  cat "$HOME/.xp-mode/current"

  fileMustContain "denny@gmail.com" "$HOME/.xp-mode/current"
  fileMustContain "mark@gmail.com"  "$HOME/.xp-mode/current"
  fileMustContain "lisa@gmail.com"  "$HOME/.xp-mode/current"

  pending "Allow spaces after commas"
