FROM elixir:1.9.0-slim AS base

RUN apt-get -qq update && \
    apt-get -qq -y install build-essential --fix-missing --no-install-recommends


ENV PROJECT_ROOT /src/ultronx

ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

COPY . .

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

RUN MIX_ENV=prod mix deps.get && \
    MIX_ENV=prod mix deps.compile

RUN MIX_ENV=prod mix compile 
RUN MIX_ENV=prod mix release

LABEL maintainer="ahsan.dar@live.com"

ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ahsan/ultronx"
LABEL org.label-schema.description="Slack Bot - ULTRONX"
LABEL org.label-schema.url="https://github.com/ahsan/ultronx"




ENTRYPOINT ["_build/prod/rel/ultronx/bin/ultronx", "start"]