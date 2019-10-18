defmodule Ultronex.Server.Heartbeat do
  @moduledoc """
  Documentation for Ultronex.Server.Heartbeat
  """
  alias Ultronex.Server.Helper, as: Helper

  def rythm do
    json_response() |> Helper.response()
  end

  def json_response do
    %{
      msg: "I don't have a heart but I am alive!"
    }
  end
end
