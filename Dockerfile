FROM node:8.15.0-stretch

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install tzdata build-essential python -y

#FROM node:16-alpine

#RUN apk add --no-cache tzdata gettext

RUN addgroup -S openhabcloud && \
    adduser -H -S -G openhabcloud openhabcloud

# Add proper timezone
ARG TZ=America/Chicago
RUN ln -s /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

RUN mkdir -p /opt/openhabcloud
COPY ./package.json /opt/openhabcloud/
#COPY deployment/docker-compose/config.json.template /opt/openhabcloud/config.json
RUN ls ./deployment
RUN mkdir /data
RUN ln -s /opt/openhabcloud/package.json /data
WORKDIR /data
RUN npm install
# && npm rebuild bcrypt --build-from-source

ENV NODE_PATH /data/node_modules

WORKDIR /opt/openhabcloud
RUN  chown -R openhabcloud:openhabcloud /opt/openhabcloud && \
        chmod -R 777 /opt/openhabcloud

USER openhabcloud

ADD . /opt/openhabcloud

EXPOSE 3000
#CMD ["node", "app.js"]

#WORKDIR /opt/openhabcloud

# Install node modules
#COPY package.json package-lock.json ./
#RUN apk update
#ENV PYTHONUNBUFFERED=1
#RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
#RUN apk add --no-cache --virtual .build-deps build-base
#RUN npm install
#RUN npm rebuild bcrypt --build-from-source
#RUN apk del .build-deps

# Prepare source tree
#RUN chown openhabcloud:openhabcloud .
#RUN mkdir logs && chown openhabcloud:openhabcloud logs
#COPY --chown=openhabcloud:openhabcloud . .

#USER openhabcloud
#EXPOSE 3000
CMD ["./run-app.sh"]
