#!/bin/bash
failures="test-failures"

: > $failures

if [ ! -z $BUILD_SERVER ]; then
    for file in ./test/*checks.sh
    do
        bash -c "$@ /bin/bash $file"
    done
    exit 0
else
    echo "Running in container. Set \`BUILD_SERVER\` to any value to run in the current directory <`pwd`>."

    sudo docker rm xp-mode-test &> /dev/null

    sudo docker build . -qt xp-mode &> /dev/null && sudo docker run -itd --name xp-mode-test xp-mode &> /dev/null

    sudo docker cp . xp-mode-test:/ 

    sudo docker exec xp-mode-test bash -c "$@ rm -r .git"

    if [[ $TEST != "" ]]; then
        echo "Running single test file <$TEST>"
        
        sudo docker exec xp-mode-test bash -c "$@ /bin/bash $TEST"
        sudo docker cp xp-mode-test:$failures - >> .tmp
    else
        for file in ./test/*checks.sh
        do
            touch .tmp

            sudo docker exec xp-mode-test bash -c "$@ /bin/bash $file"
            sudo docker cp xp-mode-test:$failures - >> .tmp

            cat .tmp >> $failures

            rm -f .tmp
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


