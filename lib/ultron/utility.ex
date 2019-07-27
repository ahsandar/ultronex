defmodule Ultron.Utility do
  def authorization_token do
    "Bearer #{slack_bot_ultron_token()}"
  end

  def start_http_poison do
    HTTPoison.start()
  end

  

  def encode_payload(attachment) do
    attachment |> Poison.encode!()
  end

  def slack_bot_ultron_token do
    System.get_env("SLACK_BOT_ULTRON")
  end

  def tesla_json_authorized_client do
    middleware = [
      {Tesla.Middleware.Headers,
       [
         {"Content-type", "application/json"},
         {"Authorization", authorization_token}
       ]}
    ]

    Tesla.client(middleware)
  end

  def tesla_get_authrorized_client do
    middleware = [
      {Tesla.Middleware.Headers, [{"Authorization", authorization_token}]}
    ]

    Tesla.client(middleware)
  end

  def random(input \\ 999) do
    Enum.random(0..input)
  end
end
