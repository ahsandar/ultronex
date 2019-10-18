defmodule Ultronex.Server.Stats do
  @moduledoc """
  Documentation for Ultronex.Server.Stats
  """
  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Server.Helper, as: Helper

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
