#!/bin/bash

# Usage: $ source xp-mode.sh && pair 1
function pair() {
    local filename="$HOME/.pairs"

    if [ ! -f $filename ]; then
        echo "Config file <$filename> is missing. Exiting."
        return
    fi
    
    local total_lines=`awk 'END {print NR}' $filename`
    
    if [ -z "$1" ]; then
        echo "You have the following <$total_lines> pairs in file <$filename>:"; echo ""
        __xp-mode-print-pairs
        return
    fi
    
    local number=$(($1<1?1:$1))

    if [ $number -gt $total_lines ]; then
        number=1
    fi
    
    local result=`cat $filename | sed ""$number"q;d"`

    local git_author_name=`echo $result | cut -d ";" -f 1 | sed 's/^[ \t]*//;s/[ \t]*$//'`
    local git_author_email=`echo $result | cut -d ";" -f 2 | sed 's/^[ \t]*//;s/[ \t]*$//'`
    local pair_initials=`echo $result | cut -d ";" -f 3 | sed 's/^[ \t]*//;s/[ \t]*$//'`

    
    export GIT_AUTHOR_NAME=$git_author_name
    export GIT_AUTHOR_EMAIL=$git_author_email
        
    echo "Set GIT_AUTHOR_NAME=$git_author_name"
    echo "Set GIT_AUTHOR_EMAIL=$git_author_email"

    echo "Author is now <$git_author_name; $git_author_email>"
    echo "Committer is now <`git config user.name`; `git config user.email`>"
}

function __xp-mode-bash-complete() {
    echo ""
    __xp-mode-print-pairs
}

function __xp-mode-filename() {
    return "$HOME/.pairs"
}

function __xp-mode-print-pairs() {
    local i=0

    while read line 
    do
        echo [$((++i))] $line
    done < "$HOME/.pairs"
    
    echo ""
}

# http://ss64.com/osx/complete.html
complete -F __xp-mode-bash-complete pair

# print completions: `complete -p | less`

