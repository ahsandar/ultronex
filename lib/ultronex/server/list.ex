defmodule Ultronex.Server.List do
  def fwd do
    ets_map() |> response
  end

  def response(map_ets) do
    cond do
      Map.equal?(map_ets, %{}) -> %{msg: "No pattern set for match"}
      true -> map_ets
    end
    |> Poison.encode!()
  end

  def ets_map() do
    pattern_list = :ets.lookup(:track, "pattern")

    Enum.map(pattern_list, fn pattern ->
      term = pattern |> elem(1)
      {term, user_list(term)}
    end)
    |> Enum.into(%{})
  end

  def user_list(term) do
    u_list = :ets.lookup(:track, term)

    Enum.map(u_list, fn user_map ->
      user_map |> elem(1)
    end)
    |> Enum.join(", ")
  end
end
