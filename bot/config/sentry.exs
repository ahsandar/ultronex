use Mix.Config

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod, :dev],
  environment_name: Mix.env()
