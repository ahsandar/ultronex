defmodule Ultronex.Server.Router do
  use Plug.Router
  use Plug.Debugger
  use NewRelic.Transaction
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(:dispatch)

  get "/heartbeat" do
    send_resp(conn, 200, "I don't have a heart but I am alive!")
  end

  get "/track" do
    send_resp(conn, 200, Ultronex.Server.Track.fwd())
  end

  get "/stats" do
    send_resp(conn, 200, Ultronex.Server.Stats.total())
  end

  match _ do
    send_resp(conn, 404, Ultronex.Server.Error.status_404())
  end
end
