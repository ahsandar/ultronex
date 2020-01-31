defmodule Ultronex.Server.Controller.Heartbeat do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Heartbeat
  """

  use Plug.Router
  use Appsignal.Instrumentation.Decorators

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  plug(:match)

  plug(:dispatch)

  get "/" do
    Appsignal.Transaction.set_action("GET /ultronex/heartbeat")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(rythm()))
  end

  @decorate transaction_event()
  def rythm do
    json_response()
  end

  def json_response do
    %{
      msg: "I don't have a heart but I am alive!"
    }
  end
end
