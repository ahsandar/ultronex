# UltronX

**TODO: Add description**


## Requirements 
* Docker
* Elixir 1.9.0
* Erlang/OTP 22

### SECRETS AND KEYS
* Set values in env.list file for docker or set those as ENV variables if running without docker.

```
ENV=<environment>
SLACK_BOT_ULTRON=x<SLACK BOT ID>
SLACK_CHANNEL_LIST=<CHANNEL ID>
ULTRON_BOT_ID=<ULTRON SLACK ID>
GIPHY_API_KEY=<GIPHY APP API KEY> 
```

`CAUTION: Running msg forwarder in memory`

`should run single instance as reads all messages by the bot for every instance.`

## Docker
> `docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t darahsan/ultronx:latest .`

> `docker run --env-file ./env.list -t darahsan/ultronx:latest`

## Docker Compose 
> `docker-compose build`

> `docker-compose up`

> `docker exec -it ultronx_bot sh` #only if you need to go in to the container

