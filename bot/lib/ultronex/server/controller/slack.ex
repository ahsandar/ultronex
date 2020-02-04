defmodule Ultronex.Server.Controller.Slack do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Slack
  """

  use Plug.Router
  use Appsignal.Instrumentation.Decorators

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  alias Ultronex.BotX, as: BotX
  alias Ultronex.Server.Helper.App, as: Helper

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)

  plug(:dispatch)

  post "/" do
    Appsignal.Transaction.set_action("POST /ultronex/slack")

    {status, body} =
      case conn.body_params do
        %{
          "msg" => %{"channel" => channel, "text" => text, "payload" => payload, "title" => title}
        } ->
          {200, process_msg(channel, text, payload, title)}

        _ ->
          Helper.unprocessable_body()
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode_to_iodata!(body))
  end

  @decorate transaction_event()
  def process_msg(channel, text, payload, title) do
    spawn(BotX, :relay_msg_to_slack, [text, payload, channel, title])

    %{
      status: "triggered",
      msg: %{"channel" => channel, "text" => text, "payload" => payload, "title" => title}
    }
  end
end
