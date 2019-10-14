On Github its a `mirror` from private Gitlab repo

# UltronEx - Ultron in Elixir

Its my first attempt at writing `elixir`, the code might not very elixirish. This is a rewrite of a slack bot I did few years ago in ruby. [Blog post](https://medium.com/@hsan_nabi_dar/ruby-vs-elixir-performance-ultron-is-dead-long-live-ultronex-f24e40a4c4d4) showcasing the results `elixir`  outperforming `ruby` by 100%

**TODO: make it more elixir-ish**

## Requirements 
* `Docker`
* `Elixir 1.9.0`
* `Erlang/OTP 22`

### SECRETS AND KEYS
* Set values in env.list file for docker or set those as ENV variables if running without docker.

```
ENV=<environment>
SLACK_BOT_ULTRON=x<SLACK BOT ID>
SLACK_CHANNEL_LIST=<CHANNEL ID>
ULTRON_BOT_ID=<ULTRON SLACK ID>
GIPHY_API_KEY=<GIPHY APP API KEY> 
HTTP_SCHEME=<http or https>
```

`CAUTION: Running msg forwarder in memory`

`should run single instance as reads all messages by the bot for every instance.`

## Docker
> `docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t darahsan/ultronex:latest .`

> `docker run --env-file ./env.list -t darahsan/ultronex:latest`

## Docker Compose 
> `docker-compose build`

> `docker-compose up`

> `docker exec -it ultronex_bot sh` #only if you need to go in to the container

## UltronEx web server

A small webserver is now running in this app to check fo `heartbeat`. You can run it in `HTTP` or `HTTPS` mode. Set the `HTTP_SCHEME` environment variable and set the right docker-compose file  

> `docker-compose -f docker-compose.yml up` #HTTPS

> `docker-compose -f docker-compose-http.yml up` #HTTP

```
Request: curl -v http://localhost:8080/heartbeat

Response: I don't have a heart but I am alive!
```

```
Request: curl -v http://localhost:8080/unknown

Response: You have entered an abyss

```