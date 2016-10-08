#!/bin/bash

sudo docker rm xp-mode-test &> /dev/null

sudo docker build . -qt xp-mode && sudo docker run -itd --name xp-mode-test xp-mode

sudo docker cp . xp-mode-test:/
sudo docker exec xp-mode-test bash -c "$@ /bin/bash ./test/checks.sh"

sudo docker stop xp-mode-test &> /dev/null
sudo docker rm xp-mode-test &> /dev/null
