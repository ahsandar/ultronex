defmodule Ultronex.Server.Stats do
  @moduledoc """
  Documentation for Ultronex.Server.Stats
  """
  use Plug.Router
  use Plug.Debugger
  use NewRelic.Transaction

  require Logger

  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Server.Helper, as: Helper

  plug(Plug.Logger, log: :debug)

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(total()))
  end

  def total do
    counters() |> Helper.response("No data available")
  end

  def counters do
    %{
      uptime: TermStorage.ets_lookup(:stats, :uptime),
      total_msg_count: TermStorage.ets_lookup(:stats, :total_msg_count),
      replied_msg_count: TermStorage.ets_lookup(:stats, :replied_msg_count),
      forwarded_msg_count: TermStorage.ets_lookup(:stats, :forwarded_msg_count),
      total_attachments_downloaded: TermStorage.ets_lookup(:stats, :total_attachments_downloaded)
    }
  end
end
