defmodule Ultron.Command.Help do
  def output(slack_message, slack_state, _msg_list) do
    IO.puts("Ultron.Command.Help.output")
    msg = output_msg(slack_message.user)
    Ultron.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def output_msg(user) do
    " <@#{user}>! , `Avengers` have let you down , no doubt ini't you came to UltronX, #{
      man_page()
    }"
  end

  def unknown(slack_message, slack_state, _msg_list) do
    IO.puts("Ultron.Command.Help.unknown")
    msg = unknown_msg(slack_message.user)
    Ultron.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def unknown_msg(user) do
    " <@#{user}>! `You talk'in to UltronX` , `You talk'in to UltronX` ?  try `@ultron help` #{
      get_random_quote()
    }"
  end

  def get_random_quote do
    Ultron.Command.Quote.get_quote_to_send()
  end

  def man_page do
    """

    -> help <command>
    command(s)
      --> greet
      --> cloudwatch
      --> mute/unmute
      --> xkcd
      --> gif
      --> quote
      --> try you best

    """
    |> Ultron.Realtime.Msg.format_block()
  end
end
