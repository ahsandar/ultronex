use Mix.Config

config :appsignal, :config,
  active: true,
  name: "ultronex",
  push_api_key:  System.get_env("APPSIGNAL_PUSH_API_KEY"), #"783cfd42-5fb3-45a5-9380-a4b68420ff9c",
  env: Mix.env
