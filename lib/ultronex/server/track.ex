defmodule Ultronex.Server.Track do
  @moduledoc """
  Documentation for Ultronex.Server.Track
  """

  use Plug.Router
  use Plug.Debugger

  alias Ultronex.Server.Helper, as: Helper

  plug(BasicAuth, use_config: {:ultronex, :basic_auth_config})

  plug(:match)

  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(fwd()))
  end

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
