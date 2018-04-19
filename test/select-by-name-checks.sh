#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    clobber $peopleFilename
    
    git config --global user.name "Ben Biddington"
    git config --global user.email "ben@gmail.com"
    
    echo "Ben; ben@gmail.com" >> $peopleFilename
    echo "Denny; denny@gmail.com" >> $peopleFilename
    echo "Mark; mark@gmail.com" >> $peopleFilename
    echo "Lisa; lisa@gmail.com" >> $peopleFilename
    
    source xp-mode.sh
}

test "select a pair by using names"

  pair "Denny,Lisa"

  gitAuthorMustEqual "Ben, Denny, Lisa" "lisa@gmail.com"

test "it always puts the first entry in the people file in first"
  
  pair "Lisa"

  gitAuthorMustEqual "Ben, Lisa" "lisa@gmail.com"

test "it uses the email address for the last person in the list"

  pair "Lisa,Denny"

  gitAuthorMustEqual "Ben, Lisa, Denny" "denny@gmail.com"

  pair "Lisa,Mark"

  gitAuthorMustEqual "Ben, Lisa, Mark" "mark@gmail.com"
  
test "it fails when name is not recognised"

  result=`pair "Malcolm"`

  mustMatch "Unknown person" "$result"

pending "it writes the full names to so we can read it from git hook and write contributors into commit"
