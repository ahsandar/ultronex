defmodule Ultron.BotX do
  use Slack

  @moduledoc """
  Documentation for Ultron.BotX.
  """

  def initialize_ets do
    IO.puts(":ets track created")
    :ets.new(:track, [:bag, :protected, :named_table, read_concurrency: true])
  end

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    initialize_ets()
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    # IO.inspect(message)
    # IO.inspect(slack)
    Ultron.Realtime.Respose.event(message, slack)
    # send_message("I got a message!", message.channel, slack)
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

  def send_msg_to_slack(message, channel, slack) do
    send_message(message, channel, slack)
  end

  def post_msg_to_slack(message, payload, channel, _slack) do
    url = "https://slack.com/api/files.upload"

    encoded_payload =
      %{
        channels: channel,
        initial_comment: message,
        content: payload,
        title: "UltronX FWD msg"
      }
      |> URI.encode_query()

    response =
      HTTPoison.post(
        url,
        encoded_payload,
        [
          {"content-type", "application/x-www-form-urlencoded"},
          {"Authorization", "Bearer #{slack_bot_ultron_token()}"}
        ]
      )

    IO.inspect(response)
  end

  def slack_bot_ultron_token do
    System.get_env("SLACK_BOT_ULTRON")
  end

  def encode_payload(attachment) do
    attachment |> Poison.encode!()
  end

  def tesla_client do
    middleware = [
      {Tesla.Middleware.Headers,
       [
         {"Content-type", "application/json"},
         {"Authorization", "Bearer #{slack_bot_ultron_token()}"}
       ]}
    ]

    Tesla.client(middleware)
  end
end
