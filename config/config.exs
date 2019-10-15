import Config
# config :slack, :web_http_client_opts, [timeout: 10_000, recv_timeout: 10_000]
config :ultronex,
  basic_auth_config: [
    username: {:system, "BASIC_AUTH_USERNAME"},
    password: {:system, "BASIC_AUTH_PASSWORD"},
    realm: {:system, "BASIC_AUTH_REALM"}
  ]

config :logger,
  backends: [{LoggerFileBackend, :info}, {LoggerFileBackend, :error}],
  utc_log: true,
  handle_otp_reports: true

config :logger, :info,
  format: "\n##### $time $metadata[$level] $levelpad #####\n$message\n",
  metadata: :all,
  path: "log/ultronex.info.log",
  level: :info

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
