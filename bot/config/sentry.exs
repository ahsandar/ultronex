use Mix.Config

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod, :dev],
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!()
