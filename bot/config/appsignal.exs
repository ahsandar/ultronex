use Mix.Config

config :appsignal, :config,
  active: true,
  name: "ultronex",
  push_api_key: System.get_env("APPSIGNAL_PUSH_API_KEY"),
  ignore_namespaces: ["ignore", "heartbeat"],
  env: Mix.env()