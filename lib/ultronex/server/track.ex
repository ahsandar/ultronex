defmodule Ultronex.Server.Track do
  @moduledoc """
  Documentation for Ultronex.Server.Track
  """
  alias Ultronex.Server.Helper, as: Helper

  def fwd do
    ets_map() |> Helper.response("No pattern set for match")
  end

  def ets_map do
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
