defmodule Ultron.Realtime.Msg do
  def parse(msg_text) do
    parsed_msg = Regex.run(~r/^<@U1KH8H9FW>\s*(\w*)\s*(.*)$/i, msg_text)

    cond do
      is_nil(parsed_msg) ->
        {nil, []}

      true ->
        [command | list] = List.delete_at(parsed_msg, 0)
        {command, list}
    end
  end

  def format_block(msg) do
    "``` #{msg} ```"
  end

  def format_sentence(msg) do
    " ` #{msg}` "
  end

  def send(msg, slack_channel, slack_state) do
    Ultron.BotX.send_msg_to_slack(msg, slack_channel, slack_state)
  end

  def post(msg, payload, channel) do
    Ultron.BotX.post_msg_to_slack(msg, payload, channel)
  end
end
