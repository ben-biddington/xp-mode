# sudo docker build --no-cache . -t xp-mode && sudo docker run -it xp-mode

FROM ubuntu

ENV TRACE=""

RUN apt-get update
RUN apt-get install -y git curl tree