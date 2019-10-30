FROM elixir:1.9.2-slim AS base

RUN apt-get -qq update && \
    apt-get -qq -y install build-essential --fix-missing --no-install-recommends

ENV PROJECT_ROOT /src/ultronex

ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN MIX_ENV=prod mix deps.get && \
    MIX_ENV=prod mix deps.compile

ARG ENV
ARG SLACK_BOT_ULTRON
ARG SLACK_CHANNEL_LIST
ARG ULTRONEX_BOT_ID
ARG IRONMAN_USER_ID
ARG GIPHY_API_KEY
ARG NEW_RELIC_APP_NAME
ARG NEW_RELIC_LICENSE_KEY
ARG HTTP_SCHEME
ARG BASIC_AUTH_USERNAME
ARG BASIC_AUTH_PASSWORD
ARG BASIC_AUTH_REALM
ARG SECRET_WEAPON
ARG SENTRY_DSN

RUN MIX_ENV=prod mix compile 
RUN MIX_ENV=prod mix release


# ---- Application Stage ----
FROM debian:stretch AS app

ENV LANG=C.UTF-8

# Install openssl
RUN apt-get update && apt-get install -y openssl

ENV PROJECT_ROOT /src/ultronex

ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

COPY --from=base /src/ultronex/_build .

LABEL maintainer="ahsan.dar@live.com"

ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ahsan/ultronex"
LABEL org.label-schema.description="Slack Bot - ULTRONEX"
LABEL org.label-schema.url="https://github.com/ahsan/ultronex"


EXPOSE 8443

ENTRYPOINT ["prod/rel/ultronex/bin/ultronex", "start"]