FROM node:16-alpine

RUN apk add --no-cache tzdata gettext

RUN addgroup -S openhabcloud && \
    adduser -H -S -G openhabcloud openhabcloud

# Add proper timezone
ARG TZ=America/Chicago
RUN ln -s /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

WORKDIR /opt/openhabcloud

# Install node modules
COPY package.json package-lock.json ./
RUN apk update
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add --no-cache --virtual .build-deps build-base
RUN npm install
RUN npm rebuild bcrypt --build-from-source
RUN apk del .build-deps

# Prepare source tree
RUN chown openhabcloud:openhabcloud .
RUN mkdir logs && chown openhabcloud:openhabcloud logs
COPY --chown=openhabcloud:openhabcloud . .

USER openhabcloud
EXPOSE 3000
CMD ["./run-app.sh"]
