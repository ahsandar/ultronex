require Logger

defmodule Ultronex.Command.Greet do
  @moduledoc """
  Documentation for Ultronex.Command.Greet
  """

  alias Ultronex.Command.Quote, as: Quote
  alias Ultronex.Realtime.Msg, as: Msg

  def hello(slack_message, slack_state, msg_list) do
    Logger.info("Ultronex.Command.Greet.hello")
    hi(slack_message, slack_state, msg_list)
  end

  def hi(slack_message, slack_state, _msg_list) do
    Logger.info("Ultronex.Command.Greet.hi")
    greeting = salutation(slack_message.user)
    Logger.info(greeting)
    Msg.send(greeting, slack_message.channel, slack_state)
  end

  def salutation(user) do
    "Hi <@#{user}>! you distub my slumber, try `@ultron help` #{get_random_quote()}"
  end

  def get_random_quote do
    Quote.get_quote_to_send()
  end
end
