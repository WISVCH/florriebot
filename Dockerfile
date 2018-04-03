FROM node:8

ADD https://ch.tudelft.nl/certs/wisvch.crt /usr/local/share/ca-certificates/wisvch.crt
RUN chmod 0644 /usr/local/share/ca-certificates/wisvch.crt && \
    update-ca-certificates

COPY . /srv/florriebot
RUN yarn

ENV HUBOT_NAME florriebot
ENV HUBOT_PORT 8080

EXPOSE ${HUBOT_PORT}

WORKDIR /srv/florriebot

CMD bin/hubot
