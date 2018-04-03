FROM node:8

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends curl ca-certificates
RUN curl -so /usr/local/share/ca-certificates/wisvch.crt https://ch.tudelft.nl/certs/wisvch.crt && \
    chmod 644 /usr/local/share/ca-certificates/wisvch.crt && \
    update-ca-certificates
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
ADD . /srv/florriebot

ENV HUBOT_NAME florriebot
ENV HUBOT_PORT 8080

EXPOSE ${HUBOT_PORT}

WORKDIR /srv/florriebot

CMD bin/hubot
