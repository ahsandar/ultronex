defmodule Ultronex.Server.Controller.Stats do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Stats
  """
  use Plug.Router
  use Appsignal.Instrumentation.Decorators

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  alias Ultronex.Server.Helper.App, as: Helper

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(:dispatch)

  get "/" do
    Appsignal.Transaction.set_action("GET /ultronex/stats")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(total()))
  end

  @decorate transaction_event()
  def total do
    Helper.counters() |> Helper.response("No data available")
  end
end
