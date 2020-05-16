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
    # pair people
    #
    if [ "$1" = "people" ]; then
        "${EDITOR:-vim}" $(__xp-mode-people-file-name)

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
    
    local firstName=${tmp[0]}
    local lastName=${tmp[@]: -1}

    for name in "${tmp[@]}"
    do
        name="$(__xp-mode-trim $name)"
        if [ $(__xp-mode-is-known-person $name) = "1" ]; then
            names+=("$(__xp-mode-get-person-name "$name")")

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
    
    local groupName=""

    for i in "${names[@]: 0: (${#names[@]} - 1)}"
    do
        groupName+=", $i"
    done

    groupName="${groupName:2}"

    if [ $numberOfNames -eq 1 ]; then
        groupName="${names[@]: -1}"
    else
        groupName="${groupName} and ${names[@]: -1}"
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
    local person=$(__xp-mode-get-person $name)

    echo ${person##*;}
}

function __xp-mode-get-person-name {
    local name=$1

    local fullName=$(__xp-mode-get-person-full-name "$name")
    local email=$(__xp-mode-get-person-email "$name")
    
    if [ "$fullName" == "$email" ]; then
        __xp-mode-trace "Returning name <$name> because <$fullName> == <$email>"
        echo "$(__xp-mode-trim "$name")"
    else
        __xp-mode-trace "Returning full name <$fullName> because <$fullName> != <$email>"
        echo "$(__xp-mode-trim "$fullName")"
    fi
}

function __xp-mode-get-person-full-name {
    local name=$1

    local person=$(__xp-mode-get-person $name)
    local fullName=$(echo "$person" | cut -d ';' -f 2)
    local trimmedName=$(__xp-mode-trim "$fullName")

    __xp-mode-trace "Full name for <$name> is <$trimmedName> and person: ${person}"

    echo "$trimmedName"
}

function __xp-mode-get-person { grep -Eir "^$1;" $(__xp-mode-people-file-name); }

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

function join { 
    delimiter="$1"
    
    shift
    
    result=""

    names="$@"

    for i in "${names[@]}"
    do
        result+="$delimiter$i"
    done

    echo "${result:1}"
}

function __xp-mode-trace {
    
    if [ "$TRACE" != "" ]; then
        mkdir logs &> /dev/null
        echo -e "[trace] "$1"" >> logs/trace-log
    fi
}

# https://www.cyberciti.biz/faq/bash-remove-whitespace-from-string/
function __xp-mode-trim {
    shopt -s extglob

    local result="${1##*( )}"
 
    echo "${result%%*( )}"

    shopt -u extglob
}

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

