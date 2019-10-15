require Logger

defmodule UltronexApp do
  use Application

  def start(_type, _args) do
    Ultronex.Utility.start_http_poison()
    Ultronex.BotX.heartbeat()

    children = [
      %{
        id: Slack.Bot,
        start:
          {Slack.Bot, :start_link,
           [Ultronex.BotX, [], Ultronex.Utility.slack_bot_ultron_token(), %{name: :ultronex_bot}]}
      },
      Plug.Cowboy.child_spec(
        scheme: Ultronex.Utility.http_scheme(),
        plug: Ultronex.Server.Router,
        options: Ultronex.Utility.http_options()
      )
    ]

    opts = [strategy: :one_for_one, name: UltonApp]
    Supervisor.start_link(children, opts)
  end
end
