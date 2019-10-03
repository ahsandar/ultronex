defmodule Ultronx.Command.Xkcd do
  def comic(slack_message, slack_state, msg_list) do
    IO.puts("Ultronx.Command.Xkcd.comic")
    comic_no = msg_list |> List.first() |> String.first()
    comic = if is_nil(comic_no), do: Ultronx.Utility.random(999), else: msg_list |> List.first()
    url = URI.encode("http://xkcd.com/#{comic}/")

    Ultronx.Realtime.Msg.send(
      " <@#{slack_message.user}>!, `I, UltronX chose this for you` #{url}",
      slack_message.channel,
      slack_state
    )
  end
end
