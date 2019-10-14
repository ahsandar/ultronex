import Config
# config :slack, :web_http_client_opts, [timeout: 10_000, recv_timeout: 10_000]
config :ultronex,
  basic_auth_config: [
    username: {:system, "BASIC_AUTH_USERNAME"},
    password: {:system, "BASIC_AUTH_PASSWORD"},
    realm: {:system, "BASIC_AUTH_REALM"}
  ]
