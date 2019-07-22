defmodule Ultron.Command.Greet do
  def hello(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Greet.hello")
    hi(slack_message, slack_state, msg_list)
  end

  def hi(slack_message, slack_state, _msg_list) do
    IO.puts("Ultron.Command.Greet.hi")
    greeting = salutation(slack_message.user)
    Ultron.Realtime.Msg.send(greeting, slack_message.channel, slack_state)
  end

  def salutation(user) do
    "Hi <@#{user}>! you distub my slumber, try `@ultron help` #{get_random_quote()}"
  end

  def get_random_quote do
    Ultron.Command.Quote.get_quote_to_send()
  end
end
