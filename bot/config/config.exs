import Config
# config :slack, :web_http_client_opts, [timeout: 10_000, recv_timeout: 10_000]
config :ultronex,
  basic_auth_config: [
    username: {:system, "BASIC_AUTH_USERNAME"},
    password: {:system, "BASIC_AUTH_PASSWORD"},
    realm: {:system, "BASIC_AUTH_REALM"}
  ],
  slack_bot_ultron: System.get_env("SLACK_BOT_ULTRON"),
  slack_channel_list: System.get_env("SLACK_CHANNEL_LIST"),
  http_scheme: System.get_env("HTTP_SCHEME"),
  secret_weapon: System.get_env("SECRET_WEAPON"),
  giphy_api_key: System.get_env("GIPHY_API_KEY"),
  ultronex_bot_id: System.get_env("ULTRONEX_BOT_ID")

config :logger,
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}],
  utc_log: true,
  handle_otp_reports: true

config :logger, :error,
  format: "\n##### $time $metadata[$level] $levelpad #####\n$message\n",
  metadata: :all,
  path: "log/ultronex.error.log",
  level: :error

config :logger, :debug,
  format: "\n##### $time $metadata[$level] $levelpad #####\n$message\n",
  metadata: :all,
  path: "log/ultronex.debug.log",
  level: :debug

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod, :dev],
  environment_name: Mix.env()
