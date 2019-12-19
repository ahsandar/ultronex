defmodule Ultronex.Realtime.Msg do
  @moduledoc """
  Documentation for Ultronex.Realtime.Msg
  """

  alias Ultronex.BotX, as: BotX

  def parse(msg_text) do
    parsed_msg =
      Regex.run(
        ~r/^<@#{Application.fetch_env!(:ultronex, :ultronex_bot_id)}>\s*(\w*)\s*(.*)$/i,
        msg_text
      )

    if is_nil(parsed_msg) do
      {nil, []}
    else
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
    BotX.send_msg_to_slack(msg, slack_channel, slack_state)
  end

  def post(msg, payload, channel) do
    BotX.post_msg_to_slack(msg, payload, channel)
  end
end
