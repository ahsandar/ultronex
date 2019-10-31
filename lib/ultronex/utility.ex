require Logger

defmodule Ultronex.Utility do
  @moduledoc """
  Documentation for Ultronex.Utility
  """
  def authorization_token do
    "Bearer #{slack_bot_ultron_token()}"
  end

  def start_http_poison do
    HTTPoison.start()
  end

  def encode_payload(attachment) do
    attachment |> Jason.encode!()
  end

  def slack_bot_ultron_token do
    Application.fetch_env!(:ultronex, :slack_bot_ultron)
  end

  def http_scheme do
    case Application.fetch_env!(:ultronex, :http_scheme) do
      "https" -> :https
      _ -> :http
    end
  end

  def http_options do
    case http_scheme() do
      :https ->
        [
          port: 8443,
          cipher_suite: :strong,
          certfile: "/src/ultronex/cert/cert.pem",
          keyfile: "/src/ultronex/cert/privkey.pem",
          cacertfile: "/src/ultronex/cert/chain.pem",
          reuse_sessions: true,
          secure_renegotiate: true
        ]

      _ ->
        [port: 8443]
    end
  end

  def tesla_json_authorized_client do
    middleware = [
      {Tesla.Middleware.Headers,
       [
         {"Content-type", "application/json"},
         {"Authorization", authorization_token()}
       ]}
    ]

    Tesla.client(middleware)
  end

  def tesla_get_authorized_client do
    middleware = [
      {Tesla.Middleware.Headers, [{"Authorization", authorization_token()}]}
    ]

    Tesla.client(middleware)
  end

  def random(input \\ 999) do
    Enum.random(0..input)
  end

  def send_error_to_sentry(msg, extra) do
    Logger.error("#{msg} : #{extra}")
    Sentry.capture_exception(msg, extra: %{extra: extra})
  end
end
