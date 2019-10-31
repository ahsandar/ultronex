require Logger

defmodule Ultronex.Command.Help do
  @moduledoc """
  Documentation for Ultronex.Command.Help
  """
  alias Ultronex.Command.Quote, as: Quote
  alias Ultronex.Realtime.Msg, as: Msg

  def execute(slack_message, slack_state, _msg_list) do
    Logger.info("Ultronex.Command.Help")
    msg = output_msg(slack_message.user)
    Logger.info(msg)
    Msg.send(msg, slack_message.channel, slack_state)
  end

  def output_msg(user) do
    " <@#{user}>! , `Avengers` have let you down , no doubt ini't you came to `UltronEx`, #{
      man_page()
    }"
  end

  def unknown(slack_message, slack_state, _msg_list) do
    Logger.info("Ultronex.Command.Help.unknown")
    msg = unknown_msg(slack_message.user)
    Logger.info(msg)
    Msg.send(msg, slack_message.channel, slack_state)
  end

  def unknown_msg(user) do
    " <@#{user}>! `You talk'in to UltronEx` , `You talk'in to UltronEx` ?  try `@ultronex help` #{
      get_random_quote()
    }"
  end

  def get_random_quote do
    Quote.get_quote_to_send() |> Quote.format()
  end

  def man_page do
    """
    command(s)
      --> help #list the command list
      --> mute/talk #TODO implement later
      --> xkcd #shows a random xkcd comic
      --> xkcd <comic no> #shows xkcd comic no
      --> gif #shows random gif
      --> gif <category> #show a random gif from the category
      --> quote #shares a quote
      --> forward <term> #sets up msg forwarding for the term from SLACK_CHANNEL_LIST
      --> stop <term> #stops msg forwarding for the term from SLACK_CHANNEL_LIST
      --> stop #stops all msg forwarding set for SLACK_CHANNEL_LIST
      --> any msg # responds with a quote

    """
    |> Msg.format_block()
  end
end
