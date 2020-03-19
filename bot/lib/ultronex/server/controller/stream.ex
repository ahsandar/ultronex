defmodule Ultronex.Server.Controller.Stream do
  @moduledoc """
  Documentation for Ultronex.Server.Controller.Stream
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
    Appsignal.Transaction.set_action("GET /ultronex/stream")

    body =
      "app/view"
      |> Path.join("stream.html.eex")
      |> EEx.eval_file([])

    conn
    |> send_resp(200, body)
  end
end
