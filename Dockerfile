# sudo docker build --no-cache . -t xp-mode && sudo docker run -it xp-mode

FROM ubuntu

RUN apt-get update
RUN apt-get install -y git curl tree

RUN git config --global user.name "The Bizzz"
RUN git config --global user.email "the.emerald.bizz@gmail.com"

