#!/bin/bash

install_dir=$HOME

echo "Installing xp-mode to <$install_dir>"

file="xp-mode.sh"
url="https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.sh"
pairs_file=$HOME/.pairs

if [ -f $file ]; then
    rm $file
fi

echo "Downloading <$url> to <$install_dir>"

curl -so $install_dir $url 

filename=$install_dir/xp-mode.sh
profile=$HOME/.bash_profile

echo "# Load xp-mode" >> $profile
echo "source "$filename"" >> $profile

echo "Updated <$profile>"

if [ ! -f $pairs_file ];
then
    touch $pairs_file
    echo "Pairs file created at <$pairs_file>"
else
    echo "Pairs file already exists at <$pairs_file>"
fi
