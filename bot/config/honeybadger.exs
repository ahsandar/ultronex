use Mix.Config

config :honeybadger,
  api_key: System.get_env("HONEYBADGER_API_KEY"),
  environment_name: Mix.env(),
  breadcrumbs_enabled: true
  exclude_envs: [:test],
  use_logger: true
