require Logger

defmodule Ultronex.Command.Forward do
  @moduledoc """
  Documentation for Ultronex.Command.Forward
  """
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

  def execute(slack_message, slack_state, msg_list) do
    Logger.info("Ultronex.Command.Forward")
    ets_key = msg_list |> List.first() |> Utility.sanitize_quotes()
    :ets.insert(:track, {"pattern", ets_key})
    :ets.insert(:track, {ets_key, slack_message.user})
    TermStorage.ets_tab2file(:track)
    msg = "<@#{slack_message.user}>! your forwarding is set for `#{ets_key}` "
    Logger.info(msg)
    Msg.send(msg, slack_message.channel, slack_state)
  end
end
