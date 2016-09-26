#!/bin/bash

#
# (1) Check that it touches .pairs when missing
#
filename="$HOME/.pairs"

cat install.sh | bash

if [ ! -f $filename ]; then
    echo "Pairs file <$filename> exists? NO"
else
    echo "Pairs file <$filename> exists? YES"
fi

# Check that it contains the current git user as line 1
