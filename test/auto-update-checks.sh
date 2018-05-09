#!/bin/bash

source "$(dirname $0)/support.sh"

function before_each {
    SKIP_DOWNLOAD=1 bash install.sh > /dev/null
    source xp-mode.sh > /dev/null
}

test "it downloads and updates \`xp-mode.sh\`"

  result=$(pair update)

  echo "$result"
  
  mustMatch "Installing xp-mode" "$result"


