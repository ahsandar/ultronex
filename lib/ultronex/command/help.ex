defmodule Ultronex.Command.Help do
  def output(slack_message, slack_state, _msg_list) do
    IO.puts("Ultronex.Command.Help.output")
    msg = output_msg(slack_message.user)
    Ultronex.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def output_msg(user) do
    " <@#{user}>! , `Avengers` have let you down , no doubt ini't you came to UltronEx, #{
      man_page()
    }"
  end

  def unknown(slack_message, slack_state, _msg_list) do
    IO.puts("Ultronex.Command.Help.unknown")
    msg = unknown_msg(slack_message.user)
    Ultronex.Realtime.Msg.send(msg, slack_message.channel, slack_state)
  end

  def unknown_msg(user) do
    " <@#{user}>! `You talk'in to UltronEx` , `You talk'in to UltronEx` ?  try `@ultron help` #{
      get_random_quote()
    }"
  end

  def get_random_quote do
    Ultronex.Command.Quote.get_quote_to_send()
  end

  def man_page do
    """
    command(s)
      --> help #list the command list
      --> hi/hello #responds with a quote
      --> mute/unmute #TODO implement later
      --> xkcd #shows a random xkcd comic
      --> xkcd <comic no> #shows xkcd comic no
      --> gif/giphy #shows random gif
      --> gif/giphy <category> #show a random gif from the category
      --> quote #shares a quote
      --> fwd <term> #sets up msg forwarding for the term from SLACK_CHANNEL_LIST
      --> stop <term> #stops msg forwarding for the term from SLACK_CHANNEL_LIST
      --> stop #stops all msg forwarding set for SLACK_CHANNEL_LIST

    """
    |> Ultronex.Realtime.Msg.format_block()
  end
end
