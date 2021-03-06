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
          secure_renegotiate: true,
          dispatch: plug_cowboy_dispatch()
        ]

      _ ->
        [
          port: 8443,
          dispatch: plug_cowboy_dispatch()
        ]
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

  def log_count(table, key, term) do
    case :ets.match_object(table, {key, term, :_}) do
      [] ->
        :ets.insert(table, {key, term, 1})

      [{k, t, count}] ->
        :ets.delete_object(table, {k, t, count})
        :ets.insert(table, {k, t, count + 1})
    end
  end

  def send_error_to_monitor(msg, extra) do
    Logger.error("#{msg} : #{extra}")
    Task.async(fn -> Sentry.capture_message(msg, extra: %{extra: extra}) end)
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

  defp plug_cowboy_dispatch do
    [
      {:_,
       [
         {"/ultronex/ws/slack", Ultronex.Server.Websocket.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {Ultronex.Server.Router, []}}
       ]}
    ]
  end
end
