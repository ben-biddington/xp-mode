#!/bin/bash
filename="$HOME/.pairs"

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    clobber $filename
}

test "(1) It touches .pairs file when missing"

  pairsFileMustNotExist $filename

  cat install.sh | bash #&> /dev/null

  pairsFileMustExist $filename

test "(2) The .pairs file has current git user added"

  cat install.sh | bash #&> /dev/null

  pairsFileMustInclude $filename "The Bizzz; the.emerald.bizz@gmail.com"

test "(3) It skips touching .pairs if it already exists"

  echo "Anyone Else; anyone.else@gmail.com" >> $filename

  cat install.sh | bash #&> /dev/null

  pairsFileMustInclude $filename "Anyone Else; anyone.else@gmail.com"

pending "It skips updating the bash profile if already modified?"
