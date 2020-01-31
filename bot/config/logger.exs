use Mix.Config

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
