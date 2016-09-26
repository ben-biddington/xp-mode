#!/bin/bash

echo "Installing xp-mode to <$PWD>"

file="xp-mode.sh"

pairs_file=$HOME/.pairs

if [ -f $file ]; then
    rm $file
fi

curl -sO https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.sh

filename=$PWD/xp-mode.sh
profile=$HOME/.bash_profile

echo "# Load xp-mode" >> $profile
echo "source "$filename"" >> $profile

echo "Updated <$profile>"

if [ -f $pairs_file ]; then
    touch $pairs_file
    echo "Pairs file created at <$pairs_file>"
else
    echo "Pairs file already exists at <$pairs_file>"
fi
