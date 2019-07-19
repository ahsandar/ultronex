defmodule UltronApp do
  use Application

  def start_http_poison do
    HTTPoison.start()
  end


  def start(_type, _args) do
    UltronX.heartbeat()
    UltronApp.start_http_poison()

    children = [
      %{
        id: Slack.Bot,
        start:
          { Slack.Bot, :start_link,
           [UltronX, [], System.get_env("SLACK_BOT_ULTRON"), %{name: :ultronx_bot}] }
      }
    ]

    opts = [strategy: :one_for_one, name: UltonApp]
    Supervisor.start_link(children, opts)
  end
end
