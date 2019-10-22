defmodule Ultronex.Server.Heartbeat do
  @moduledoc """
  Documentation for Ultronex.Server.Heartbeat
  """

  def rythm do
    json_response()
  end

  def json_response do
    %{
      msg: "I don't have a heart but I am alive!"
    }
  end
end
