use Mix.Config

config :new_relic_agent,
  app_name: System.get_env("NEW_RELIC_APP_NAME"),
  license_key: System.get_env("NEW_RELIC_LICENSE_KEY")
