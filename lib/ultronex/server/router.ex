defmodule Ultronex.Server.Router do
  use Plug.Router
  use Plug.Debugger
  use NewRelic.Transaction

  require Logger

  alias Ultronex.Server.Error, as: Error

  plug(Plug.Logger, log: :debug)

  plug(Plug.Static, at: "/", from: :ultronex, only_matching: ["favicon"])

  plug(:match)

  plug(:dispatch)

  forward("/ultronex/heartbeat", to: Ultronex.Server.Heartbeat)
  forward("/ultronex/track", to: Ultronex.Server.Track)
  forward("/ultronex/stats", to: Ultronex.Server.Stats)
  forward("/ultronex/slack", to: Ultronex.Server.Slack)

  match _ do
    conn |> response_encoder(404, Poison.encode!(Error.status_404()))
  end

  def response_encoder(conn, status, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, json)
  end
end
