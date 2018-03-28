#!/bin/bash

set -e

filename="$HOME/.pairs"
peopleFilename="$HOME/.people"

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "Ben Biddington"
    git config --global user.email "ben@gmail.com"
    
    echo "Ben; Ben Biddington; ben@gmail.com" >> $peopleFilename
    echo "Denny; Denny; denny@gmail.com" >> $peopleFilename
    echo "Mark; Mark; mark@gmail.com" >> $peopleFilename
    echo "Lisa; Lisa; lisa@gmail.com" >> $peopleFilename
    
    source xp-mode.sh
}

test "(1) select a pair by using names"

  pair "Denny,Lisa"

  gitAuthorMustEqual "Ben, Denny and Lisa" "lisa@gmail.com"
