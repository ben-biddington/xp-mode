#!/bin/bash

sudo docker rm xp-mode-test

sudo docker build . -qt xp-mode && sudo docker run -itd --name xp-mode-test xp-mode

sudo docker cp . xp-mode-test:/
#sudo docker exec xp-mode-test bash -c "cat install.sh | bash"
sudo docker exec xp-mode-test bash -c "/bin/bash ./test/checks.sh"

sudo docker stop xp-mode-test
sudo docker rm xp-mode-test
