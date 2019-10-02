defmodule UltronApp do
  use Application

  def start(_type, _args) do
    Ultron.Utility.start_http_poison()
    Ultron.BotX.heartbeat()

    children = [
      %{
        id: Slack.Bot,
        start:
          {Slack.Bot, :start_link,
           [Ultron.BotX, [], Ultron.Utility.slack_bot_ultron_token(), %{name: :ultronx_bot}]}
      },
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Ultron.Server.Router, options: [port: 8085])
    ]

    opts = [strategy: :one_for_one, name: UltonApp]
    Supervisor.start_link(children, opts)
  end
end
