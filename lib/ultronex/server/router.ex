defmodule Ultronex.Server.Router do
  use Plug.Router
  use Plug.Debugger
  use NewRelic.Transaction
  alias Ultronex.Server.Track, as: Track
  alias Ultronex.Server.Stats, as: Stats
  alias Ultronex.Server.Error, as: Error
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(Plug.Static, at: "/", from: :ultronex, only_matching: ["favicon"])

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(:dispatch)

  get "/heartbeat" do
    send_resp(conn, 200, "I don't have a heart but I am alive!")
  end

  get "/track" do
    send_resp(conn, 200, Track.fwd())
  end

  get "/stats" do
    send_resp(conn, 200, Stats.total())
  end

  match _ do
    send_resp(conn, 404, Error.status_404())
  end
end
