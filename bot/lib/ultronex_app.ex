require Logger

defmodule UltronexApp do
  use Application

  @moduledoc """
  Documentation for UltronexApp
  """

  alias Ultronex.BotX, as: BotX
  alias Ultronex.Server.Router, as: Router
  alias Ultronex.Utility, as: Utility
  alias Ultronex.StorageServer, as: StorageServer

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
      ),
      %{
        id: StorageServer,
        start:
          {StorageServer, :start_link, [%{task: "snapshot", args: [], interval: 900_000}]}
      }
    ]

    opts = [strategy: :one_for_one, name: UltronexApp]
    Supervisor.start_link(children, opts)
  end

  def initialize do
    Utility.start_http_poison()
    BotX.heartbeat()
    {:ok, _} = Application.ensure_all_started(:appsignal)
  end
end
