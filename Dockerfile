# sudo docker build ~/sauce/xp-mode -t xp-mode && sudo docker run -it xp-mode

FROM ubuntu

RUN apt-get update
RUN apt-get install -y git curl

RUN git config --global user.name "The Bizzz"
RUN git config --global user.email "the.emerald.bizz@gmail.com"

RUN git config  --global -l