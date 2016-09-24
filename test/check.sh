#/bin/bash

# Check that it touches .pairs

filename="$HOME/.pairs"

if [ ! -f $filename ]; then
    echo "Pairs file <$filename> exists? NO"
fi
