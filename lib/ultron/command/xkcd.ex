defmodule Ultron.Command.Xkcd do
  def comic(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Xkcd.comic")
    comic_no = msg_list |> List.first() |> String.first()
    comic = if is_nil(comic_no), do: Ultron.Utility.random(999), else: msg_list |> List.first()
    url = URI.encode("http://xkcd.com/#{comic}/")

    Ultron.Realtime.Msg.send(
      " <@#{slack_message.user}>!, `I, UltronX chose this for you` #{url}",
      slack_message.channel,
      slack_state
    )
  end
end
