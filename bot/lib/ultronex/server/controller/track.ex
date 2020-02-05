defmodule Ultronex.Server.Controller.Track do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Track
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
    Appsignal.Transaction.set_action("GET /ultronex/track")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, JiffyEx.encode!(fwd()))
  end

  @decorate transaction_event()
  def fwd do
    Helper.ets_map() |> Helper.response("No pattern set for match")
  end
end
