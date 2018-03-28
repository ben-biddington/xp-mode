#!/bin/bash

function __xp-mode-dynamic-pair {
    __xp-mode-export "Ben, Denny and Lisa" "lisa@gmail.com"
    
    return
}

# Usage: $ source xp-mode.sh && pair 1
function pair() {
    local valid='^0-9$'

    if [[ ! "$1" =~ [0-9] ]]; then
        __xp-mode-dynamic-pair "$1"
       return
    fi
    
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

    __xp-mode-export "$git_author_name" "$git_author_email"
}

function __xp-mode-export {
    export GIT_AUTHOR_NAME=$1
    export GIT_AUTHOR_EMAIL=$2
        
    echo "Set GIT_AUTHOR_NAME=$1"
    echo "Set GIT_AUTHOR_EMAIL=$2"

    echo "Author is now <$1; $2>"
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

