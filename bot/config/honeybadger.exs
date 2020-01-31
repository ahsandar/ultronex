use Mix.Config

config :honeybadger,
  api_key: System.get_env("HONEYBADGER_API_KEY"),
  environment_name: Mix.env(),
  exclude_envs: [:test],
  use_logger: true
