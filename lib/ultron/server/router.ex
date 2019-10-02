defmodule Ultron.Server.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
plug(Plug.Logger, log: :debug)


plug(:match)

plug(:dispatch)


# TODO: add routes!

# Simple GET Request handler for path /hello
  get "/heartbeat" do
      send_resp(conn, 200, "I don't have a heart but I am alive!")
  end

  match _ do

    send_resp(conn, 404, "You have entered an abyss")

end

end