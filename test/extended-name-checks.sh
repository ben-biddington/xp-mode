#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    clobber $peopleFilename
    
    git config --global user.name "Ben Biddington"
    git config --global user.email "ben@gmail.com"

    SKIP_DOWNLOAD=1 bash install.sh; source xp-mode.sh
    
    echo "Ben;   Ben Biddington;   ben@gmail.com"   >> $peopleFilename
    echo "Denny; Dan O'Donnell;    denny@gmail.com" >> $peopleFilename
    echo "Mark;  Mark Lint;        mark@gmail.com"  >> $peopleFilename
    echo "Lisa;  Lisa Shickadance; lisa@gmail.com"  >> $peopleFilename
}

# TEST=./test/extended-name-checks.sh ./test.sh

pending "how to use full names"

  pair Ben,Lisa

  gitAuthorMustEqual "Ben Biddington and Lisa Shickadance" "lisa@gmail.com"