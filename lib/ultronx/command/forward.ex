defmodule Ultronx.Command.Forward do
  def fwd(slack_message, slack_state, msg_list) do
    IO.puts("Ultronx.Command.Forward.fwd")
    ets_key = msg_list |> List.first() |> sanitize_quotes()
    :ets.insert(:track, {"pattern", ets_key})
    :ets.insert(:track, {ets_key, slack_message.user})
    msg = "<@#{slack_message.user}>! your forwarding is set for `#{ets_key}` "
    Ultronx.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def stop(slack_message, slack_state, msg_list) do
    IO.puts("Ultronx.Command.Forward.stop")
    ets_key = msg_list |> List.first() |> sanitize_quotes()

    cond do
      :ets.member(:track, ets_key) ->
        :ets.delete_object(:track, {ets_key, slack_message.user})
        pattern_msg = remove_pattern_match(ets_key)

        msg =
          "<@#{slack_message.user}>! your forwarding is stopped for `#{ets_key}` \n `#{
            pattern_msg
          }`"

        Ultronx.Realtime.Msg.send(msg, slack_message.channel, slack_state)

      ets_key |> String.first() |> is_nil() ->
        stop_all_forwarding(slack_message, slack_state)

      true ->
        msg = "<@#{slack_message.user}>! you sure? no forwarding found for `#{ets_key}`"
        Ultronx.Realtime.Msg.send(msg, slack_message.channel, slack_state)
    end
  end

  def remove_pattern_match(ets_key) do
    cond do
      :ets.member(:track, ets_key) ->
        "Other users are still subscribed to this pattern"

      true ->
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

      Ultronx.Realtime.Msg.send(msg, slack_message.channel, slack_state)
    end)
  end

  def sanitize_quotes(msg) do
    String.replace(msg, ~r/“|”/, ~s("))
  end
end
