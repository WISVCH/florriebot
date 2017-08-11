FROM wisvch/debian:stretch

RUN apt-get update && apt-get install -y nodejs nodejs-legacy && rm -rf /var/lib/apt/lists/*
ADD . /srv/florriebot

ENV HUBOT_NAME florriebot
ENV HUBOT_PORT 8080

EXPOSE ${HUBOT_PORT}

WORKDIR /srv/florriebot

CMD bin/hubot
