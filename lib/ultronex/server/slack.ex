defmodule Ultronex.Server.Slack do
  @moduledoc """
  Documentation for Ultronex.Server.Slack
  """

  use Plug.Router
  use Plug.Debugger

  alias Ultronex.BotX, as: BotX
  alias Ultronex.Server.Helper, as: Helper

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)

  plug(:dispatch)

  post "/" do
    {status, body} =
      case conn.body_params do
        %{"msg" => %{"channel" => channel, "text" => text, "payload" => payload}} ->
          {200, process_msg(channel, text, payload)}

        _ ->
          Helper.unprocessable_body()
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def process_msg(channel, text, payload) do
    spawn(BotX, :send_payload_to_slack, [text, payload, channel])
    %{status: "triggered", msg: %{"channel" => channel, "text" => text, "payload" => payload}}
  end
end
