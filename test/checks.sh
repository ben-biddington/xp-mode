#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    clobber $filename
    clobber $peopleFilename
}

test "(1) It touches .pairs file when missing"

  fileMustNotExist $filename

  SKIP_DOWNLOAD=1 bash install.sh
  
  fileMustExist $filename

test "(2) The .pairs file has current git user added"

  SKIP_DOWNLOAD=1 bash install.sh

  git config --global --list

  fileMustInclude $filename "The Bizzz; the.emerald.bizz@gmail.com"

test "(3) It skips touching .pairs if it already exists"

  echo "Anyone Else; anyone.else@gmail.com" >> $filename

  cat install.sh | bash #&> /dev/null

  fileMustInclude $filename "Anyone Else; anyone.else@gmail.com"

test "(4) It puts 'xp-mode.sh' in your home directory"

  cat install.sh | bash #&> /dev/null

  fileMustExist "$HOME/xp-mode.sh"

test "(5) It touches .people file when missing"

  fileMustNotExist $peopleFilename

  SKIP_DOWNLOAD=1 bash install.sh #&> /dev/null

  fileMustExist $peopleFilename

test "(6) It moves ~/.pairs and ~/.people to ~/.xp-mode/ if it is present"

  echo "A" > "$HOME/.pairs"
  echo "B" > "$HOME/.people"
  
  SKIP_DOWNLOAD=1 bash install.sh #&> /dev/null

  fileMustNotExist "$HOME/.pairs"
  fileMustNotExist "$HOME/.people"

  fileMustEqual "A" $filename
  fileMustEqual "B" $peopleFilename
  
pending "The info command tells you where your pairs file is"
pending "It skips updating the bash profile if already modified?"

