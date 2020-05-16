#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    clobber $peopleFilename
    
    git config --global user.name "Ben Biddington"
    git config --global user.email "ben@gmail.com"

    SKIP_DOWNLOAD=1 bash install.sh; source xp-mode.sh
    
    echo "Ben;   Ben Biddington;   ben@gmail.com"   >> $peopleFilename
    echo "Denny; Dan O'Donnell;    denny@gmail.com" >> $peopleFilename
    echo "Mark;                    mark@gmail.com"  >> $peopleFilename
    echo "Lisa;  Lisa Shickadance; lisa@gmail.com"  >> $peopleFilename
    echo "Rip;   Rip Van Winkle;   rvw@gmail.com"   >> $peopleFilename
}

# TEST=./test/extended-name-checks.sh ./test.sh

test "how to use full names"

  pair Ben,Lisa,Denny

  gitAuthorMustEqual "Ben Biddington, Lisa Shickadance and Dan O'Donnell" "denny@gmail.com"

  pair Ben,Lisa

  gitAuthorMustEqual "Ben Biddington and Lisa Shickadance" "lisa@gmail.com"

test "You may mix the styles"

  pair Ben,Lisa,Mark

  gitAuthorMustEqual "Ben Biddington, Lisa Shickadance and Mark" "mark@gmail.com"

  pair Ben,Mark,Lisa

  gitAuthorMustEqual "Ben Biddington, Mark and Lisa Shickadance" "lisa@gmail.com"

test "Full names may contain multiple words"

  pair Ben,Rip,Mark

  gitAuthorMustEqual "Ben Biddington, Rip Van Winkle and Mark" "mark@gmail.com"