#!/bin/bash

install_dir=$HOME

echo "Installing xp-mode to <$install_dir>"

file="xp-mode.sh"
url="https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.sh"
home=$HOME/.xp-mode
original_pairs_file=$HOME/.pairs
pairs_file=$home/pairs
original_people_file=$HOME/.people
people_file=$home/people
filename=$install_dir/xp-mode.sh
profile=$HOME/.bash_profile

if [ ! -d $home ]; then
    mkdir $home
fi

if [ -f $original_pairs_file ]; then
    mv $original_pairs_file $home
fi

if [ -f $original_people_file ]; then
    mv $original_people_file $home
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

if [ ! -f $pairs_file ]; then
    touch $pairs_file
    echo "Pairs file created at <$pairs_file>"

    pair_1="`git config --global user.name`; `git config --global user.email`"
    
    echo $pair_1 > $pairs_file

    echo "Entry <$pair_1> added to <$pairs_file>"
else
    echo "Pairs file already exists at <$pairs_file>"
fi

if [ ! -f $people_file ]; then
    touch $people_file
    echo "People file created at <$people_file>"
else
    echo "People file already exists at <$people_file>"
fi
