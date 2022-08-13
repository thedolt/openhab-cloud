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
RUN apk add --no-cache --virtual .build-deps build-base python
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
