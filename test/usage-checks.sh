#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"
    
    clobber $peopleFilename
    clobber $filename

    SKIP_DOWNLOAD=1 bash install.sh
    
    echo "Ben and Richard; ben@gmail.com" >> $filename

    source xp-mode.sh

    cat "$filename"
}

test "(1) select a pair by index"

  pair 1

  gitAuthorMustEqual "The Bizzz" "the.emerald.bizz@gmail.com"

  pair 2

  gitAuthorMustEqual "Ben and Richard" "ben@gmail.com"

test "(2) invalid index uses first"

  pair -1

  gitAuthorMustEqual "The Bizzz" "the.emerald.bizz@gmail.com"

  pair 1000

  gitAuthorMustEqual "The Bizzz" "the.emerald.bizz@gmail.com"

test "(3) no args prints pairs file"

  result=`pair`

  mustMatch "You have the following" "$result"

test "(4) \`pair solo\` clears author"

  pair 1 

  pair solo

  gitAuthorMustBeUnset


  
