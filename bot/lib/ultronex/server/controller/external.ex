defmodule Ultronex.Server.Controller.External do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.External
  """

  use Plug.Router
  use Appsignal.Instrumentation.Decorators

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler
  use Sentry.Plug

  alias Ultronex.Server.Helper.App, as: Helper

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(:dispatch)

  get "/" do
    Appsignal.Transaction.set_action("GET /ultronex/external")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(error_map()))
  end

  @decorate transaction_event()
  def error_map do
    Helper.ets_to_map(:external, :errors) |> Helper.response("No errors recorded yet")
  end
end
