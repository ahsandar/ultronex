defmodule Ultronex.Server.Helper.App do
  @moduledoc """
  Documentation for Ultronex.Server.Helper.App
  """

  alias Ultronex.Realtime.TermStorage, as: TermStorage

  def response(response_map, msg \\ "empty response") do
    if Map.equal?(response_map, %{}) do
      %{msg: msg}
    else
      response_map
    end
  end

  def unprocessable_body do
    {422, %{msg: "Unprocessable request body"}}
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

  def counters do
    %{
      uptime: TermStorage.ets_lookup(:stats, :uptime),
      total_msg_count: TermStorage.ets_lookup(:stats, :total_msg_count),
      replied_msg_count: TermStorage.ets_lookup(:stats, :replied_msg_count),
      forwarded_msg_count: TermStorage.ets_lookup(:stats, :forwarded_msg_count),
      total_attachments_downloaded: TermStorage.ets_lookup(:stats, :total_attachments_downloaded),
      total_messages_slacked: TermStorage.ets_lookup(:stats, :total_messages_slacked),
      snapshot: TermStorage.ets_lookup(:stats, :snapshot)
    }
  end
end
