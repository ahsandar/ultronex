defmodule Ultron.Command.Xkcd do
  def comic(slack_message, slack_state, _msg_list) do
    IO.puts("Ultron.Command.Xkcd.comic")

    Ultron.Realtime.Msg.send(
      " <@#{slack_message.user}>!, `I, UltronX chose this for you` http://xkcd.com/#{
        random_comic()
      }/",
      slack_message.channel,
      slack_state
    )
  end

  def random_comic do
    Enum.random(1..999)
  end
end
