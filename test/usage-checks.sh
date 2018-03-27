#!/bin/bash

set -e

filename="$HOME/.pairs"
peopleFilename="$HOME/.people"

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    source "$HOME/.bash_profile"
    echo "Ben and Richard; ben@gmail.com" >> $filename
}

test "(1) select a pair by index"

  pair 1

  gitAuthorMustEqual "The Bizzz" "the.emerald.bizz@gmail.com"

  pair 2

  gitAuthorMustEqual "Ben and Richard" "ben@gmail.com"
  
