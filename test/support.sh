# colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting#bash_tipscolors_and_formatting_ansivt100_control_sequences
set -e

filename="$HOME/.xp-mode/pairs"
peopleFilename="$HOME/.xp-mode/people"
failures="test-failures"
name=""

function fileMustNotExist {
    debug "Checking that file <$1> is missing"
    
    if [ -f $1 ]; then
        fail "\nExpected file <$1> to be missing, but it is present"
    fi
}

function fileMustEqual {
    local expected=$1
    local file=$2

    fileMustExist $file

    local actual=$(cat $file)

    if [[ ! $expected = $actual ]]; then
        fail "\nExpected the contents of file <$file> to be: \n\n$expected\n\nGot:\n\n$actual"
    fi
}

function fileMustContain {
    local expectedLine=$1
    local file=$2

    fileMustExist $file

    local matches=$(grep -Eir $expectedLine $file | wc -l)

    if [[ $matches -ne 1 ]]; then
        fail "\nExpected\n\n$(cat $file)\n\nto contain:\n\n$expectedLine"
    fi
}


function fileMustNotContain {
    local expectedLine=$1
    local file=$2

    fileMustExist $file

    local matches=$(grep -Eir $expectedLine $file | wc -l)

    if [[ $matches -ne 0 ]]; then
        fail "\nExpected\n\n$(cat $file)\n\n *not* to contain:\n\n$expectedLine"
    fi
}

function fileMustExist {
    debug "Checking that file <$1> is present"
    
    if [ ! -f $1 ]; then
        fail "\nExpected file <$1> to exist"
    fi
}

function gitAuthorMustBeUnset {
    if [ ! -z "$GIT_AUTHOR_NAME" ]; then
        fail "Expected the <GIT_AUTHOR_NAME> env var to be unset, but it has value <$GIT_AUTHOR_NAME>"
    fi
}

function gitAuthorMustEqual {
    if [ "$GIT_AUTHOR_NAME" != "$1" ]; then
        fail "\nExpected GIT_AUTHOR_NAME environment variabe to be <$1>, got <$GIT_AUTHOR_NAME>"
    fi

    if [ "$GIT_AUTHOR_EMAIL" != "$2" ]; then
        fail "\nExpected GIT_AUTHOR_EMAIL environment variabe to be <$2>, got <$GIT_AUTHOR_EMAIL>"
    fi
}

function mustBe {
    local expected="${1##*( )}" #${var##*( )}
    local actual=$2

    if [[ -z $2 ]]; then
        fail "\`mustMatch\`: No actual value supplied, it should be the second argument."
    fi

    if [[ ! "$actual" = "$expected" ]]; then
        fail "Expected:\n\n$expected\n\nGot:\n\n$actual"
    fi
}

function mustMatch {
    local expected="$1"
    local actual="$2"

    if [[ -z $2 ]]; then
        fail "\`mustMatch\`: No actual value supplied, it should be the second argument."
    fi

    if [[ ! "$actual" =~ "$expected" ]]; then
        fail "Expected <$actual> to match pattern <$expected>"
    fi
}

function mustEqual {
    local expected=$1
    local actual=$2
    local message=$3
    
    if [[ "$actual" -ne "$expected" ]]; then
        fail "Expected <$actual> to equal <$expected>\n$message"
    fi
}

function mustExitOkay {
    if [[ ! "$?" = 0 ]]; then
        fail "Expected exit code <0>, got <$?>"
    fi
}

function test {
    name="$@"
    before_each
    title "$@"
}

function title {
    green "\n$1\n"
}

function debug {
    if [ ! -z $DEBUG ]; then
        yellow "[DEBUG] $1"
    fi
}

function green {
    echo -e "\e[32m$1\e[0m"
}

function fail {
    echo -e "$0 -- $name\n\t$1" >> $failures
    red "$1"
}

function red {
    echo -e "\e[31m$1\e[0m"
}

function pending { yellow "\n[PENDING] $1\n"; }

function yellow {
    echo -e "\e[33m$@\e[0m"
}

function clobber {
    if [ -f $1 ]; then
        debug "Clobbering <$1>"
        rm $1
    fi
}

function fileMustInclude {
    file=$1
    expected=$2
    
    debug "Checking file <$file> for line matching <$expected>"
    
    first_line=`head -n 1 $file`

    debug "Comparing <$first_line> with <$expected>"
    
    if [ ! "$first_line" == "$expected" ]; then
       red "\nExpected <$first_line> to equal <$expected>"
    fi
}

function before_each
{
  :
}

function after_each
{
  :
}

function fn_exists()
{
    type $1 | grep -q 'shell function'
}
