#!/bin/bash

function pair() {
    #
    # pair update
    #
    if [ "${1:-}" = "update" ]; then
       __xp-mode-update $@

       return
    fi

    #
    # pair solo
    #

    if [ "$1" = "solo" ]; then
        local currentAuthorsFile="$(__xp-mode-current-authors-file-name)"
        
        if [ -f $currentAuthorsFile ]; then rm $currentAuthorsFile; fi
        
        __xp-mode-export "$(git config user.name)" "$(git config user.email)"

        return
    fi

    #
    # pair hooks
    #
    
    if [ "$1" = "hooks" ]; then
        __xp-mode-install-git-hooks "$@"

        return
    fi
    
    #
    # pair Ben, Denny, Lisa
    #
     __xp-mode-dynamic-pair $@
}

function __xp-mode-dynamic-pair {
    local currentEmailsFilename="$(__xp-mode-current-authors-file-name)"
    
    local filename=$(__xp-mode-people-file-name)

    :> $currentEmailsFilename

    local names=()
    local tmp
    
    IFS=',' read -r -a tmp <<< "$@"
    for name in "${tmp[@]}"
    do
        if [ $(__xp-mode-is-known-person $name) = "1" ]; then
            names+=($(echo $name | tr -d ' '))

            __xp-mode-save-author-email $name
        elif [ $(__xp-mode-is-known-person $name) -gt "1" ]; then
            echo "The person <$name> is duplicated in $filename:"
            cat "$filename"
            return
        else
            echo "Unknown person <$name> in file $filename:"
            cat "$filename"
            return
        fi
    done

    local numberOfNames="${#names[@]}"
    local indexOfSecondLastName=$((numberOfNames-1))
    local lastName=${names[numberOfNames - 1]}

    local groupName=$(join "," ${names[@]:0:$indexOfSecondLastName})

    groupName="${groupName//,/, }"

    if [ $numberOfNames -eq 1 ]; then
        groupName="$lastName"
    else
        groupName="${groupName} and $lastName"
    fi
    
    __xp-mode-export "$groupName" $(__xp-mode-get-person-email $lastName)
}

function __xp-mode-install-git-hooks {
    local f="$PWD/.git/hooks/commit-msg"

    if [ "$2" = "-d" ]; then
        if [ -f $f ]; then
            if [[ $(grep -Eir "#xp-mode" $f | wc -l) -gt 0 ]]; then
                rm -f $f
            fi
        else
            echo "The file <$f> does not exist, nothing to delete"
        fi
        return
    fi
    
    if [ ! -f $f ]; then
        touch $f; chmod +x $f

        cat << 'EOF' > $f
#!/bin/bash
      #xp-mode

      file="$HOME/.xp-mode/current"

      if [ -f "$file" ]; then 
        commitMsg="$1"

        echo "" >> $commitMsg 

        for email in $(cat "$file"); do 
          echo "Co-authored-by: Mob <$email>" >> $commitMsg
        done; 
     fi; 
EOF
        
    else
        echo "You already have a commit-msg hook present at <$f>, skipping"
    fi
}

function __xp-mode-people-file-name {
    echo "$HOME/.xp-mode/people"
}

function __xp-mode-is-known-person {
    local count=`cat $(__xp-mode-people-file-name) | cut -d ";" -f 1 | grep -Eir "$1$" - | wc -l`
    
    echo $count
}

function __xp-mode-get-person-email {
    local record=`cat $(__xp-mode-people-file-name) | grep -Eir "^$1;" -`
    local email=`echo $record | cut -d ';' -f 2`

    echo $email
}

#
# Save the supplied user's email address to `./.xp-mode/current`
#
function __xp-mode-save-author-email {
    local currentEmailsFilename=$(__xp-mode-current-authors-file-name)
    local committerEmail=$(git config user.email)
    local email=$(__xp-mode-get-person-email $1)

    if [ "$email" != "$committerEmail" ]; then
       echo $email >> $currentEmailsFilename
    fi
}

function join { local IFS="$1"; shift; echo "$*"; }

function __xp-mode-current-authors-file-name {
    echo "$HOME/.xp-mode/current"
}

#
# update source
#
function __xp-mode-update {
    echo "Running the following in 5s: curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.sh | bash && source ~/xp-mode.sh"

    sleep 5

    result=$(curl -s https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.sh | bash && source ~/xp-mode.sh)

    echo "$result"
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
    local names=(solo update)
    echo names
}

# http://ss64.com/osx/complete.html
# complete -W "solo,update" pair

# print completions: `complete -p | less`

