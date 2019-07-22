defmodule UltronApp do
  use Application

  def start_http_poison do
    HTTPoison.start()
  end

  def slack_bot_ultron_token do
    System.get_env("SLACK_BOT_ULTRON")
  end

  def start(_type, _args) do
    start_http_poison()
    Ultron.BotX.heartbeat()

    children = [
      %{
        id: Slack.Bot,
        start:
          {Slack.Bot, :start_link,
           [Ultron.BotX, [], slack_bot_ultron_token(), %{name: :ultronx_bot}]}
      }
    ]

    opts = [strategy: :one_for_one, name: UltonApp]
    Supervisor.start_link(children, opts)
  end
end
