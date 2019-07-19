defmodule UltronX do
  use Slack

  @moduledoc """
  Documentation for UltronX.
  """

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    IO.inspect(message)
    send_message("I got a message!", message.channel, slack)
    {:ok, state}
  end

  def handle_event(_message, _slack, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

  def heartbeat do
    IO.puts("I am alive got heartbeat")
  end
end
