On Github its a `mirror` from private Gitlab repo

# UltronEx - Ultron in Elixir

Its my first attempt at writing `elixir`, the code might not very elixirish. This is a rewrite of a slack bot I did few years ago in ruby. [Blog post](https://medium.com/@hsan_nabi_dar/ruby-vs-elixir-performance-ultron-is-dead-long-live-ultronex-f24e40a4c4d4) showcasing the results `elixir`  outperforming `ruby` by 100%

![Image](/priv/ultronex.jpg)

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
* `Docker`
* `Elixir 1.9.2`
* `Erlang/OTP 22`

### SECRETS AND KEYS
* Set values as `ENV` variables and in `env.list` file for docker or set those as `ENV` variables if running without docker.

```
ENV=<environment>
SLACK_BOT_ULTRON=x<SLACK BOT ID>
SLACK_CHANNEL_LIST=<CHANNEL ID>
ULTRON_BOT_ID=<ULTRON SLACK ID>
GIPHY_API_KEY=<GIPHY APP API KEY> 
HTTP_SCHEME=<http or https>
BASIC_AUTH_USERNAME=<username>
BASIC_AUTH_PASSWORD=<password>
BASIC_AUTH_REALM=<realm>
SECRET_WEAPON=<your secret command>
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
  --data '{"msg": {\n	"channel": "U08MG2700",\n	"text": "test",\n	"payload": "testing"\n	\n}\n	\n}'

Response: {
    "status": "triggered",
    "msg": {
        "text": "test",
        "payload": "testing",
        "channel": "U08MG2700"
    }
}

status: 200
```


```
Request: curl -v http://localhost:8080/ultronex/unknown
```
![Image](/priv/404.png)

