FROM node:8

ADD https://ch.tudelft.nl/certs/wisvch.crt /usr/local/share/ca-certificates/wisvch.crt
RUN chmod 0644 /usr/local/share/ca-certificates/wisvch.crt && \
    update-ca-certificates

WORKDIR /srv/florriebot
COPY . .
RUN yarn

ENV HUBOT_NAME florriebot
ENV HUBOT_PORT 8080

EXPOSE ${HUBOT_PORT}

RUN groupadd -r florriebot --gid=999 && useradd --no-log-init -r -g florriebot --uid=999 florriebot
USER 999

WORKDIR /srv/florriebot

CMD bin/hubot
