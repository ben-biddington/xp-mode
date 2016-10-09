#!/bin/bash
filename="$HOME/.pairs"

source "$(dirname $0)/support.sh"

title "(1) Check that it touches .pairs when missing"

pairsFileMustNotExist $filename

cat install.sh | bash #&> /dev/null

pairsFileMustExist $filename

title "(2) The .pairs file has current git user as entry number one"

clobber $filename

git config --global user.name "The Bizzz"
git config --global user.email "the.emerald.bizz@gmail.com"

cat install.sh | bash #&> /dev/null

pairsFileMustInclude $filename "The Bizzz; the.emerald.bizz@gmail.com"
