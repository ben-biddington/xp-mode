#!/bin/bash
filename="$HOME/.pairs"

source "$(dirname $0)/support.sh"

echo ""
echo "(1) Check that it touches .pairs when missing"
echo ""

pairsFileMustNotExist $filename

cat install.sh | bash #&> /dev/null

pairsFileMustExist $filename

# Check that it contains the current git user as line 1
