#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    clobber $peopleFilename
    clobber $filename
    
    echo "The Bizzz; the.emerald.bizz@gmail.com" >> $filename
    echo "Ben and Richard; ben@gmail.com" >> $filename

    source xp-mode.sh
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


  
