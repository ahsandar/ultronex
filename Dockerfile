FROM elixir:1.9.0-slim AS base

ENV PROJECT_ROOT /src/ultronx

ENV PATH ${PROJECT_ROOT}/bin:$PATH

WORKDIR ${PROJECT_ROOT}

COPY . .
RUN export MIX_ENV=prod && \
    mix escript.build

LABEL maintainer="ahsan.dar@live.com"

ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ahsan/ultronx"
LABEL org.label-schema.description="Slack Bot - ULTRONX"
LABEL org.label-schema.url="https://github.com/ahsan/ultronx"




ENTRYPOINT ["./ultronx"]