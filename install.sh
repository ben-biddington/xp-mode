#!/bin/bash

install_dir=$HOME

echo "Installing xp-mode to <$install_dir>"

file="xp-mode.sh"
url="https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.sh"
home=$HOME/.xp-mode
people_file=$home/people
filename=$install_dir/xp-mode.sh
profile=$HOME/.bash_profile

if [ ! -d $home ]; then
    mkdir $home
fi

if [ -z $SKIP_DOWNLOAD ]; then
    if [ -f $filename ]; then
        echo "Deleting file at <$filename>"
        rm $filename
    fi

    echo "Downloading <$url> to <$filename>"

    curl -s $url > $filename
else
    cp xp-mode.sh $filename
fi

touch $profile

if [[ $(grep -Eir "# xp-mode" "$profile" | wc -l) -eq 0 ]]; then
    echo "source "$filename" # xp-mode" >> $profile

    echo "Updated <$profile>"
fi

if [ ! -f $people_file ]; then
    touch $people_file
    echo "People file created at <$people_file>"
else
    echo "People file already exists at <$people_file>"
fi
