# colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting#bash_tipscolors_and_formatting_ansivt100_control_sequences
function debug {
    if [ ! -z $DEBUG ]; then
        echo -e "\e[90m[DEBUG] $1\e[0m"
    fi
}

function pairsFileMustNotExist {
    debug "Checking that file <$1> is missing"
    
    if [ -f $1 ]; then
        echo -e "\n\e[31mExpected file <$1> to be missing, but it is present \e[0m"
        exit 1
    fi
}

function pairsFileMustExist {
    debug "Checking that file <$1> is present"
    
    if [ ! -f $1 ]; then
        echo -e "\n\e[31mExpected file <$1> to exist\e[0m"
        exit 1
    fi
}
