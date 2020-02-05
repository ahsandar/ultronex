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
    attachment |> JiffyEx.encode!()
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

  def header_json_authorized_client do
    [Authorization: authorization_token(), "Content-type": "application/json"]
  end

  def header_get_authorized_client do
    [Authorization: authorization_token()]
  end

  def random(input \\ 999) do
    Enum.random(0..input)
  end

  def send_error_to_monitor(msg, extra) do
    Logger.error("#{msg} : #{extra}")
    spawn(Honeybadger, :notify, [msg, %{extra: extra}])
  end

  def get_module_atom(module) do
    module_cmd = "Elixir.Ultronex.Command.#{String.capitalize(module)}"

    try do
      Logger.info("Creating existing atom : #{module_cmd}")
      String.to_existing_atom(module_cmd)
    rescue
      e in ArgumentError ->
        Logger.debug("atom not exist : #{module_cmd}" <> e.message)
        Logger.info("Creating a new atom : #{module_cmd}")
        String.to_atom(module_cmd)
    end
  end

  def get_channel_list_to_monitor do
    Application.fetch_env!(:ultronex, :slack_channel_list) |> String.split(",")
  end

  def sanitize_quotes(msg) do
    String.replace(msg, ~r/“|”/, ~s("))
  end
end
