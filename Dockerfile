# Development Application

FROM wunsh/alpine-elixir-elm as app

MAINTAINER Docdog Developers <dev@docdog.io>


ARG BUILD_ENV=prod

ARG PORT=4000

ENV \
  APP_NAME=docdog \
  \
  MIX_ENV=$BUILD_ENV \
  PORT=$PORT \
  \
  MIX_HOME=/opt/mix \
  HEX_HOME=/opt/hex \
  HOME=/opt/app

EXPOSE ${PORT}


RUN \
  echo "Build Docker image for Mix env: ${MIX_ENV}." && \
  \
  mkdir -p ${HOME} && \
  chmod -R 777 ${HOME} && \
  apk update && \
  apk --no-cache --update add \
    g++ inotify-tools make python yarn && \
  update-ca-certificates --fresh && \
  rm -rf /var/cache/apk/* && \
  \
  mix local.hex --force && \
  mix local.rebar --force


# Cache Mix dependencies

WORKDIR ${HOME}

ADD mix.exs mix.lock ./

RUN mix do deps.get --only=${MIX_ENV}, deps.compile


# Cache Yarn dependencies

WORKDIR assets

ADD assets/package.json assets/yarn.lock ./

RUN yarn install


# Cache Elm dependencies

WORKDIR elm

ADD assets/elm/elm-package.json ./

RUN elm package install -y


WORKDIR ${HOME}

ADD . .


WORKDIR assets/elm

RUN elm-make Main.elm --output=../js/main.js


WORKDIR assets

RUN if [ ${MIX_ENV} = "prod" ]; then yarn run deploy; else yarn run build; fi


WORKDIR ${HOME}

RUN mix do compile, phx.digest

RUN \
  if [ ${MIX_ENV} = "prod" ]; then \
    mix release --env=${MIX_ENV}; \
    \
    RELEASE_DIR=`ls -d _build/${MIX_ENV}/rel/${APP_NAME}/releases/*/` && \
    mkdir /release && \
    tar -xf "${RELEASE_DIR}${APP_NAME}.tar.gz" -C /release; \
  fi


CMD ["mix", "phx.server"]


# Release Application

FROM bitwalker/alpine-erlang:21.0.3

MAINTAINER Docdog Developers <dev@docdog.io>


ARG BUILD_ENV=prod

ARG PORT=4000

ENV \
  APP_NAME=docdog \
  HOME=/opt/app \
  MIX_ENV=$BUILD_ENV \
  PORT=$PORT \
  REPLACE_OS_VARS=true

EXPOSE ${PORT}


COPY --from=app /release/ .

RUN \
  apk update && \
  apk add inotify-tools


ENTRYPOINT ["/opt/app/bin/docdog"]

CMD ["foreground"]
