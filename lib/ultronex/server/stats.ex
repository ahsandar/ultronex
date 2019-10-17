defmodule Ultronex.Server.Stats do
  def total() do
    counters() |> response
  end

  def response(map_ets) do
    cond do
      Map.equal?(map_ets, %{}) -> %{msg: "No data available"}
      true -> map_ets
    end
    |> Poison.encode!()
  end

  def counters() do
    %{
      uptime: Ultronex.Realtime.TermStorage.ets_lookup(:stats, :uptime),
      total_msg_count: Ultronex.Realtime.TermStorage.ets_lookup(:stats, :total_msg_count),
      replied_msg_count: Ultronex.Realtime.TermStorage.ets_lookup(:stats, :replied_msg_count),
      forwarded_msg_count: Ultronex.Realtime.TermStorage.ets_lookup(:stats, :forwarded_msg_count),
      total_attachments_downloaded:
        Ultronex.Realtime.TermStorage.ets_lookup(:stats, :total_attachments_downloaded)
    }
  end
end
