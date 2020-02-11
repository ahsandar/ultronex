On Github its a `mirror` from private Gitlab repo

### Would like to thank [AppSignal](https://appsignal.com) for considering my project under their OpenSource initiative and setting up a free account for APM. I hope this helps others at using their product. Its one of the most comprehensive tools available for `Elixir` monitoring.

# UltronEx - Ultron in Elixir

Its my first attempt at writing `elixir`, the code might not very elixirish. This is a rewrite of a slack bot I did few years ago in ruby. [Blog post](https://medium.com/@hsan_nabi_dar/ruby-vs-elixir-performance-ultron-is-dead-long-live-ultronex-f24e40a4c4d4) showcasing the results `elixir`  outperforming `ruby` by 100%

![Image](/bot/priv/ultronex.jpg)

```
command(s)
      --> help #list the command list
      --> mute/talk #TODO implement later
      --> xkcd #shows a random xkcd comic
      --> xkcd <comic no> #shows xkcd comic no
      --> gif #shows random gif
      --> gif <category> #show a random gif from the category
      --> quote #shares a quote
      --> forward <term> #sets up msg forwarding for the term from SLACK_CHANNEL_LIST
      --> stop <term> #stops msg forwarding for the term from SLACK_CHANNEL_LIST
      --> stop #stops all msg forwarding set for SLACK_CHANNEL_LIST
      --> any msg # responds with a quote

```

**TODO: make it more elixir-ish**

## Requirements 
* `Docker` & `Docker Compose`
* `Elixir 1.9.4`
* `Erlang/OTP 22`

### SECRETS AND KEYS
* Set values as `ENV` variables and in `env.list` file for docker or set those as `ENV` variables if running without docker.

```
#common
export BASIC_AUTH_USERNAME=<set value>
export BASIC_AUTH_PASSWORD=<set value>
export BASIC_AUTH_REALM=<set value>
#scope
export ENABLE_BASIC_AUTH=<set value>
#haproxy
export HAPROXY_STATS_URI=<set value>
export HAPROXY_STATS_REFRESH=<set value>
export HAPROXY_HTTP_SCHEME=<set value>
#grafana
export GF_SECURITY_ADMIN_PASSWORD=<set value>
#bot 
export ENVIRONMENT=<set value>
export SLACK_BOT_ULTRON=<set value>
export SLACK_CHANNEL_LIST=<set value>
export ULTRONEX_BOT_ID=<set value>
export IRONMAN_USER_ID=<set value>
export GIPHY_API_KEY=<set value>
export NEW_RELIC_APP_NAME=<set value>
export NEW_RELIC_LICENSE_KEY=<set value>
export HTTP_SCHEME=<set value>
export SECRET_WEAPON=<set value>
export SENTRY_DSN=<set value>
export HONEYBADGER_API_KEY=<set value>
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

A small webserver is now running in this app to check for `heartbeat`, `stats` and `track`. You can run it in `HTTP` or `HTTPS` mode. Set the `HTTP_SCHEME` environment variable and set the right docker-compose file  

> `docker-compose -f docker-compose.yml up` #HTTPS

> `docker-compose -f docker-compose-http.yml up` #HTTP

```
Request: curl -v http://localhost:8080/ultronex/heartbeat

Response: {"msg":"I don't have a heart but I am alive!"}

status: 200
```


```
Password protected endpoint

Request: curl -v -H"Authorization: Basic username:password" http://localhost:8080/ultronex/stats

Response: {"uptime":"2019-10-16 16:01:05.571045Z","total_msg_count":90075,"total_attachments_downloaded":64992,"replied_msg_count":32,"forwarded_msg_count":14}

status: 200
```


```
Password protected endpoint

Request: curl -v -H"Authorization: Basic username:password" http://localhost:8080/ultronex/track

Response: {"stark":"U08MG273O"}

status: 200
```


```
Password protected endpoint

Request: curl --request POST \
  --url http://localhost:8080/ultronex/slack \
  --header 'Accept: */*' \
  --header 'Accept-Encoding: gzip, deflate' \
  --header 'Authorization: Basic username:password' \
  --header 'Cache-Control: no-cache' \
  --header 'Connection: keep-alive' \
  --header 'Content-Length: 81' \
  --header 'Content-Type: application/json' \
  --header 'Host: localhost:8080' 
  --header 'cache-control: no-cache' \
  --data '{"msg": {\n	"channel": "U08MG2700",\n	"text": "test",\n	"payload": "testing",\n "title": "Hola"\n	\n}\n	\n}'

Response: {
    "id": "e21f9216-43b4-45d9-978b-de94da273654",
    "msg": {
        "channel": "U08MG27P0",
        "text": "test",
        "title": "Hola"
    },
    "status": "triggered"
}

status: 200
```

```
Password protected endpoint

Request: curl -v -H"Authorization: Basic username:password" http://localhost:8080/ultronex/external

Response: {"errors":{"Slack error : remote closed":12}}

status: 200
```


```
Request: curl -v http://localhost:8080/ultronex/unknown
```
![Image](/bot/priv/404.png)

# WeaveScope
`http://localhost:8040`

![Image](/bot/priv/weavescope.png)

# HAProxy
`http://localhost:13000`

![Image](/bot/priv/haproxy.png)