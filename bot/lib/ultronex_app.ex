require Logger

defmodule UltronexApp do
  use Application

  @moduledoc """
  Documentation for UltronexApp
  """

  alias Ultronex.BotX, as: BotX
  alias Ultronex.Server.Router, as: Router
  alias Ultronex.Utility, as: Utility

  def start(_type, _args) do
    initialize()

    children = [
      %{
        id: Slack.Bot,
        start:
          {Slack.Bot, :start_link,
           [BotX, [], Utility.slack_bot_ultron_token(), %{name: :ultronex_bot}]}
      },
      Plug.Cowboy.child_spec(
        scheme: Utility.http_scheme(),
        plug: Router,
        options: Utility.http_options()
      )
    ]

    opts = [strategy: :one_for_one, name: UltronexApp]
    {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)
    Supervisor.start_link(children, opts)
  end

  def initialize do
    Utility.start_http_poison()
    BotX.heartbeat()
  end
end