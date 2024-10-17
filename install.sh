#!/bin/bash

install_dir=$HOME

echo -e "Installing xp-mode to <$install_dir>\n"

file="xp-mode.sh"
url="https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.sh"
home=$HOME/.xp-mode
people_file=$home/people
filename=$install_dir/xp-mode.sh
profile=$HOME/.bash_profile

if [ ! -d "$home" ]; then
    mkdir "$home"
fi

if [ -z $SKIP_DOWNLOAD ]; then
    if [ -f "$filename" ]; then
        echo -e "Deleting file at <$filename>\n"
        rm "$filename"
    fi

    upstreamHash=$(curl -s $url | md5sum - | awk '{ print $1 }')

    echo -e "Downloading <$url> to <$filename>\n"

    echo -e "Hash for <$url> is:\n\n\t$upstreamHash\n"

    curl -s $url > "$filename"

    localHash=$(md5sum "$filename" | awk '{ print $1 }')

    echo -e "Hash for <$filename> is:$localHash\n\n\t\n"
else
    cp xp-mode.sh "$filename"
fi

touch "$profile"

if [[ $(grep -Eir "# xp-mode" "$profile" | wc -l) -eq 0 ]]; then
    echo "source "$filename" # xp-mode" >> "$profile"

    echo "Updated <$profile>"
fi

if [ ! -f "$people_file" ]; then
    touch "$people_file"
    echo "People file created at <$people_file>"
else
    echo "People file already exists at <$people_file>, leaving it alone"
fi
