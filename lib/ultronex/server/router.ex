defmodule Ultronex.Server.Router do
  use Plug.Router
  use Plug.Debugger
  use NewRelic.Transaction
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  get "/heartbeat" do
    send_resp(conn, 200, "I don't have a heart but I am alive!")
  end

  get "/list" do
    send_resp(conn, 200, Ultronex.Server.List.fwd())
  end

  match _ do
    send_resp(conn, 404, "You have entered an abyss")
  end
end
