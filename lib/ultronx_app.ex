defmodule UltronxApp do
  use Application

  def start(_type, _args) do
    Ultronx.Utility.start_http_poison()
    Ultronx.BotX.heartbeat()

    children = [
      %{
        id: Slack.Bot,
        start:
          {Slack.Bot, :start_link,
           [Ultronx.BotX, [], Ultronx.Utility.slack_bot_ultron_token(), %{name: :ultronx_bot}]}
      },
      Plug.Cowboy.child_spec(
        scheme: Ultronx.Utility.http_scheme(),
        plug: Ultronx.Server.Router,
        options: Ultronx.Utility.http_options()
      )
    ]

    opts = [strategy: :one_for_one, name: UltonApp]
    Supervisor.start_link(children, opts)
  end
end
