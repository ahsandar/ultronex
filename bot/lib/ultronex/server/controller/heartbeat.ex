defmodule Ultronex.Server.Controller.Heartbeat do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Heartbeat
  """

  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler
  use Sentry.Plug

  plug(:match)

  plug(:dispatch)

  get "/" do
    Appsignal.Transaction.set_namespace(:heartbeat)
    Appsignal.Transaction.set_action("GET /ultronex/heartbeat")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(rythm()))
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
