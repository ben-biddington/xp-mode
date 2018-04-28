#!/bin/bash

function __xp-mode-pairs-file-name {
    echo "$HOME/.xp-mode/pairs"
}

function __xp-mode-people-file-name {
    echo "$HOME/.xp-mode/people"
}

function __xp-mode-is-known-person {
    local count=`cat $(__xp-mode-people-file-name) | cut -d ";" -f 1 | grep -Eir "$1" - | wc -l`
    
    echo $count
}

function __xp-mode-get-person-email {
    local record=`cat $(__xp-mode-people-file-name) | grep -Eir "^$1" -`
    local email=`echo $record | cut -d ';' -f 2`

    echo $email
}

function __xp-mode-is-numeric {
    echo "$1" | grep -Eir "^[-0-9]+$" - | wc -l
}

function __xp-mode-install-git-hooks {
    local f="$PWD/.git/hooks/pre-commit"
    
    if  [ ! -f $f ]; then
        touch $f
    else
        echo "You already have a pre-commit hook present at <$f>, skipping"
    fi
}

function __xp-mode-dynamic-pair {
    if [ "$1" = "solo" ]; then
        __xp-mode-export "$(git config user.name)" "$(git config user.email)"
        return
    fi

    if [ "$1" = "hooks" ]; then
        __xp-mode-install-git-hooks
        return
    fi

    local arrayOfNames
    
    IFS=',' read -r -a arrayOfNames <<< "$1"
    local filename=$(__xp-mode-people-file-name)
    local x=`echo $1 | cut -d "," -f 1`
    local names=`cat $filename | cut -d ";" -f 1`
    local namesList=`echo "$names" | tr '\n' ', '`
    local currentEmailsFilename="$HOME/.xp-mode/current"

    :> $currentEmailsFilename
    
    local groupName="`cat $filename | head -n 1 | cut -d ";" -f 1`"

    for element in "${arrayOfNames[@]}"
    do
        if [ $(__xp-mode-is-known-person $element) = "1" ]; then
            groupName="$groupName, $element"
            echo $(__xp-mode-get-person-email $element) >> $currentEmailsFilename
        elif [ $(__xp-mode-is-known-person $element) -gt "1" ]; then
            echo "The person <$element> is duplicated in $filename:"
            cat "$filename"
            return
        else
            echo "Unknown person <$element> in file $filename:"
            cat "$filename"
            return
        fi
    done

    local numberOfNames="${#arrayOfNames[@]}"
    
    local lastName=${arrayOfNames[numberOfNames - 1]}
     
    __xp-mode-export "$groupName" $(__xp-mode-get-person-email $lastName)
}

# Usage: $ source xp-mode.sh && pair 1
function pair() {
    local argumentIsNumeric=$(__xp-mode-is-numeric "$1")

    if [ ! -z "$1" ] && [[ "$argumentIsNumeric" -eq "0" ]]; then
       __xp-mode-dynamic-pair "$1"
       return
    fi

    local filename=$(__xp-mode-pairs-file-name)

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

function __xp-mode-print-pairs() {
    local i=0

    while read line 
    do
        echo [$((++i))] $line
    done < $(__xp-mode-pairs-file-name)
    
    echo ""
}

# http://ss64.com/osx/complete.html
complete -F __xp-mode-bash-complete pair

# print completions: `complete -p | less`

