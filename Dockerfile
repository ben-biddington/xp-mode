# sudo docker build . -t xp-mode && sudo docker run -it xp-mode
# sudo docker build --no-cache . -t xp-mode && sudo docker run -it xp-mode

FROM ubuntu

RUN apt-get update
RUN apt-get install -y git curl

RUN git config --global user.name "The Bizzz"
RUN git config --global user.email "the.emerald.bizz@gmail.com"

RUN git config  --global -l

RUN git clone https://github.com/ben-biddington/xp-mode.git

WORKDIR /xp-mode

RUN git checkout f/loating

WORKDIR /

RUN chmod +x ./xp-mode/install.sh

RUN echo ./xp-mode/install.sh | bash

#
# TESTS
#

RUN echo "Running tests"

RUN ./xp-mode/test/check.sh
