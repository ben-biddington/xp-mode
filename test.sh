#!/bin/bash

if [ ! -z $BUILD_SERVER ]; then
    #todo: fix, it is missing files
    bash -c "$@ /bin/bash ./test/checks.sh"
    exit 0
else echo "Running in container. Set \`BUILD_SERVER\` to any value to run in the current directory <`pwd`>."
fi

sudo docker rm xp-mode-test &> /dev/null

sudo docker build . -qt xp-mode &> /dev/null && sudo docker run -itd --name xp-mode-test xp-mode &> /dev/null

sudo docker cp . xp-mode-test:/ 

if [ $TEST != "" ]; then
    echo "Running single test file <$TEST>"
    sudo docker exec xp-mode-test bash -c "$@ /bin/bash $TEST"
else

    for file in ./test/*checks.sh
    do
        sudo docker exec xp-mode-test bash -c "$@ /bin/bash $file"
    done
fi
sudo docker stop xp-mode-test &> /dev/null
sudo docker rm xp-mode-test &> /dev/null
