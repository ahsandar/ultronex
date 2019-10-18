defmodule Ultronex.Server.Helper do
  @moduledoc """
  Documentation for Ultronex.Server.Helper
  """
  def response(response_map, msg \\ "empty response") do
    if Map.equal?(response_map, %{}) do
      %{msg: msg}
    else
      response_map
    end
  end
end
