defmodule Ultronex.Server.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler
  use Sentry.Plug
  use Appsignal.Plug

  require Logger

  alias Ultronex.Server.Controller.Error, as: Error

  @template_dir "app/view"

  plug(Plug.Logger, log: :debug)

  plug(Plug.Static,
    at: "/",
    from: :ultronex,
    only_matching: ["favicon", "stylesheets", "js", "html"]
  )

  plug(:match)

  plug(:dispatch)

  forward("/ultronex/heartbeat", to: Ultronex.Server.Controller.Heartbeat)
  forward("/ultronex/track", to: Ultronex.Server.Controller.Track)
  forward("/ultronex/stats", to: Ultronex.Server.Controller.Stats)
  forward("/ultronex/slack", to: Ultronex.Server.Controller.Slack)
  forward("/ultronex/stream", to: Ultronex.Server.Controller.Stream)
  forward("/ultronex/external", to: Ultronex.Server.Controller.External)

  match _ do
    Appsignal.Transaction.set_action("GET /")
    conn |> render(404, "404.html", var: Error.status_404())
  end

  def response_encoder(conn, status, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, json)
  end

  def render(conn, status, template, assigns \\ []) do
    body =
      @template_dir
      |> Path.join(template)
      |> String.replace_suffix(".html", ".html.eex")
      |> EEx.eval_file(assigns)

    send_resp(conn, status, body)
  end
end
