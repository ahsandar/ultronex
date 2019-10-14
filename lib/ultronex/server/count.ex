defmodule Ultronex.Server.Count do
  def total do
    a = :ets.lookup(:track, "slack_msg_count")
    IO.puts(a)
    a
  end

  def response(map_ets) do
    cond do
      Map.equal?(map_ets, %{}) -> %{msg: "No data available"}
      true -> map_ets
    end
    |> Poison.encode!()
  end
end
