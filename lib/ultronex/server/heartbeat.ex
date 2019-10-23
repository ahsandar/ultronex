defmodule Ultronex.Server.Heartbeat do
  @moduledoc """
  Documentation for Ultronex.Server.Heartbeat
  """

  use Plug.Router
  use Plug.Debugger
  use NewRelic.Transaction

  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(rythm()))
  end

  def rythm do
    json_response()
  end

  def json_response do
    %{
      msg: "I don't have a heart but I am alive!"
    }
  end
end
