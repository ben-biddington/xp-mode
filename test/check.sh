#!/bin/bash

# Check that it touches .pairs

filename="$HOME/.pairs"

if [ ! -f $filename ]; then
    echo "Pairs file <$filename> exists? NO"
else
    echo "Pairs file <$filename> exists? YES"
fi

# Check that it contains the current git user as line 1
