# colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting#bash_tipscolors_and_formatting_ansivt100_control_sequences
function debug {
    if [ ! -z $DEBUG ]; then
        echo -e "\e[33m[DEBUG] $1\e[0m"
    fi
}

function pairsFileMustNotExist {
    debug "Checking that file <$1> is missing"
    
    if [ -f $1 ]; then
        red "\nExpected file <$1> to be missing, but it is present"
        exit 1
    fi
}

function pairsFileMustExist {
    debug "Checking that file <$1> is present"
    
    if [ ! -f $1 ]; then
        red "\nExpected file <$1> to exist"
        exit 1
    fi
}

function title {
    green "\n$1\n"
}

function green {
    echo -e "\e[32m$1\e[0m"
}

function red {
    echo -e "\e[31m$1\e[0m"
}

function clobber {
    if [ -f $1 ]; then
        debug "Clobbering <$1>"
        rm $1
    fi
}


function pairsFileMustInclude {
    file=$1
    expected=$2
    
    debug "Checking file <$file> for line matching <$expected>"
    
    first_line=`head -n 1 $file`

    if [ "$first_line" != "$expected" ]; then
       red "\nExpected <$first_line> to equal <$expected>"
    fi
}
