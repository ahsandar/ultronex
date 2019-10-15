require Logger

defmodule Ultronex.Command.Xkcd do
  def comic(slack_message, slack_state, msg_list) do
    Logger.info("Ultronex.Command.Xkcd.comic")
    comic_no = msg_list |> List.first() |> String.first()
    comic = if is_nil(comic_no), do: Ultronex.Utility.random(999), else: msg_list |> List.first()
    url = URI.encode("http://xkcd.com/#{comic}/")
    msg = " <@#{slack_message.user}>!, `I, UltronEx chose this for you` #{url}"
    Logger.info(msg)

    Ultronex.Realtime.Msg.send(
      msg,
      slack_message.channel,
      slack_state
    )
  end
end
