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
  use Sentry.Plug

  alias Ultronex.Slack.Api, as: SlackApi
  alias Ultronex.Server.Helper.App, as: Helper
  alias Ultronex.Server.Websocket.SocketHandler, as: SocketHandler

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

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
    |> send_resp(status, Jason.encode!(body))
  end

  @decorate transaction_event()
  def process_msg(channel, text, payload, title) do
    uuid_v4 = UUID.uuid4()
    Task.async(fn -> SlackApi.relay_msg_to_slack(text, payload, channel, title) end)
    Task.async(fn -> format_msg_for_stream(uuid_v4, title, text, payload) end)

    %{
      status: "triggered",
      msg: %{"channel" => channel, "text" => text, "title" => title},
      id: uuid_v4
    }
  end

  def format_msg_for_stream(
        uuid,
        title,
        text,
        payload,
        registry_key \\ %{registry_key: "/ultronex/ws/slack"}
      ) do
    msg = Helper.pretty_print_slack_msg(uuid, title, text, payload)
    SocketHandler.websocket_send_msg(msg, registry_key)
  end
end
