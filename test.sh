#!/bin/bash
failures="test-failures"

: > $failures

# Docker cp wildcard does not work:
# sudo docker cp xp-mode-test:logs/* - >> logs/ # https://github.com/mikexstudios/dokku-app-configfiles/pull/4
function copyLogs() {
    logs=$(sudo docker exec xp-mode-test bash -c "$@ ls logs")

    for logFile in "${logs[@]}"; do
        if [ "$logFile" != "" ]; then 
            sudo docker cp xp-mode-test:logs/$logFile - >> logs/$logFile
        fi
    done
}

if [ ! -z $BUILD_SERVER ]; then
    for file in ./test/*checks.sh
    do
        bash -c "$@ /bin/bash $file"
    done
else
    echo "Running in container. Set \`BUILD_SERVER\` to any value to run in the current directory <`pwd`>."

    sudo docker rm -f xp-mode-test &> /dev/null

    if [[ ! -z $BUILD ]]; then
        echo "Building container"
        sudo docker build . -t xp-mode
    fi
    
    echo "Starting container"

    sudo docker run -itd --name xp-mode-test xp-mode #&> /dev/null

    echo "Copying files"

    rm -fr ./logs && mkdir ./logs 

    sudo docker cp . xp-mode-test:/ 
    sudo docker exec xp-mode-test bash -c "$@ rm -r .git" 

    if [[ $TEST != "" ]]; then
        echo "Running single test file <$TEST>"
        
        sudo docker exec -e "TRACE=$TRACE" xp-mode-test bash -c "$@ /bin/bash $TEST"
        
        sudo docker cp xp-mode-test:$failures - >> $failures
        
        copyLogs
    else
        for file in ./test/*checks.sh
        do
            sudo docker exec xp-mode-test bash -c "$@ /bin/bash $file"
            sudo docker cp xp-mode-test:$failures - >> $failures
        done
    fi
    sudo docker stop xp-mode-test &> /dev/null
    sudo docker rm xp-mode-test &> /dev/null
fi

source "test/support.sh"

if [[ "$(cat $failures | wc -l)" -gt "0" ]]; then
    red "\n\nTESTS FAILED\n"
    
    cat "$failures"
    exit 1
else
    green "\nAll tests passed\n"
    exit 0
fi


