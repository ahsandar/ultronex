defmodule Ultron.Command.Forward do
  def fwd(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Forward.fwd")
    ets_key = sanitize_quotes(List.first(msg_list))
    :ets.insert(:track, {"pattern", ets_key})
    :ets.insert(:track, {ets_key, slack_message.user})
    msg = "<@#{slack_message.user}>! your forwarding is set for `#{ets_key}` "
    Ultron.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def stop(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Forward.stop")
    ets_key = sanitize_quotes(List.first(msg_list))

    if :ets.member(:track, ets_key) do
      :ets.delete_object(:track, {"pattern", ets_key})
      :ets.delete_object(:track, {ets_key, slack_message.user})
      msg = "<@#{slack_message.user}>! your forwarding is stopped for `#{ets_key}` "
      Ultron.Realtime.Msg.send(msg, slack_message.channel, slack_state)
    end
  end

  def sanitize_quotes(msg) do
    String.replace(msg, ~r/“|”/, ~s("))
  end
end
