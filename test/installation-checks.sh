#!/bin/bash

source "$(dirname $0)/support.sh"
profile="$HOME/.bash_profile"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    clobber $filename
    clobber $peopleFilename
    clobber $profile
}

test "(4) It puts 'xp-mode.sh' in your home directory"

  cat install.sh | bash #&> /dev/null

  fileMustExist "$HOME/xp-mode.sh"

test "(5) It touches .people file when missing"

  fileMustNotExist $peopleFilename

  SKIP_DOWNLOAD=1 bash install.sh #&> /dev/null

  fileMustExist $peopleFilename

test "It skips updating the bash profile if already modified"

  SKIP_DOWNLOAD=1 bash install.sh #&> /dev/null
  SKIP_DOWNLOAD=1 bash install.sh #&> /dev/null

  mustEqual 1 $(grep -Eir "# xp-mode" "$profile" | wc -l) "Expected the file <$profile> to have been updated only once"
