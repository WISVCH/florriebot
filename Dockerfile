FROM wisvch/debian:stretch

RUN apt-get update && apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
ADD . /srv/florriebot

ENV HUBOT_NAME florriebot
ENV HUBOT_PORT 8080

EXPOSE ${HUBOT_PORT}

WORKDIR /srv/florriebot

CMD bin/hubot
