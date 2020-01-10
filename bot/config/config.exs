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

config :new_relic_agent,
  app_name: System.get_env("NEW_RELIC_APP_NAME"),
  license_key: System.get_env("NEW_RELIC_LICENSE_KEY")

config :logger,
  backends: [:console],
  utc_log: true,
  handle_otp_reports: true

config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad #####\n$message\n",
  metadata: :all,
  level: :error

config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad #####\n$message\n",
  metadata: :all,
  level: :debug

config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad #####\n$message\n",
  metadata: :all,
  level: :info

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod, :dev],
  environment_name: Mix.env()
