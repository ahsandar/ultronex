require Logger

defmodule Ultronex.Command.Stop do
  @moduledoc """
  Documentation for Ultronex.Command.Stop
  """
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

  def execute(slack_message, slack_state, msg_list) do
    Logger.info("Ultronex.Command.Forward.stop")
    ets_key = msg_list |> List.first() |> Utility.sanitize_quotes()

    cond do
      :ets.member(:track, ets_key) ->
        :ets.delete_object(:track, {ets_key, slack_message.user})
        pattern_msg = remove_pattern_match(ets_key)
        TermStorage.ets_tab2file(:track)

        msg =
          "<@#{slack_message.user}>! your forwarding is stopped for `#{ets_key}` \n `#{
            pattern_msg
          }`"

        Logger.info(msg)
        Msg.send(msg, slack_message.channel, slack_state)

      ets_key |> String.first() |> is_nil() ->
        stop_all_forwarding(slack_message, slack_state)

      true ->
        msg = "<@#{slack_message.user}>! you sure? no forwarding found for `#{ets_key}`"
        Logger.info(msg)
        Msg.send(msg, slack_message.channel, slack_state)
    end
  end

  def remove_pattern_match(ets_key) do
    if :ets.member(:track, ets_key) do
      "Other users are still subscribed to this pattern"
    else
      :ets.delete_object(:track, {"pattern", ets_key})
      "No one else is subscribed to this pattern"
    end
  end

  def stop_all_forwarding(slack_message, slack_state) do
    pattern_list = :ets.lookup(:track, "pattern")

    Enum.each(pattern_list, fn pattern ->
      match = pattern |> elem(1)
      :ets.delete_object(:track, {match, slack_message.user})
      pattern_msg = remove_pattern_match(match)

      msg =
        "<@#{slack_message.user}>! your forwarding is stopped for `#{match}` , `#{pattern_msg}`"

      Logger.info(msg)
      Msg.send(msg, slack_message.channel, slack_state)
    end)
  end
end
