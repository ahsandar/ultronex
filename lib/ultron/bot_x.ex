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

  def post_msg_to_slack(message, payload, channel, slack) do
    url = "https://slack.com/api/files.upload"

    # encoded_payload =
    #   %{
    #     channel: channel,
    #     initial_comment: message,
    #     as_user: true,
    #     content: payload,
    #     filename: "payload",
    #     title: "UltronX FWD msg"
    #   }
    #   |> encode_payload()

    # mp =
    #   Tesla.Multipart.new()
    #   |> Tesla.Multipart.add_field("channels", channel)
    #   |> Tesla.Multipart.add_field("initial_comment", message)
    #   |> Tesla.Multipart.add_field("filename", "payload")
    #   |> Tesla.Multipart.add_field("title", "UltronX FWD msg")
    #   |> Tesla.Multipart.add_file_content(payload, "file")

    # IO.inspect(mp)

    # {:ok, response} =
    #   Tesla.post(url, mp,
    #     headers: [
    #       {"content-type", "multipart/form-data"},
    #       {"Authorization", "Bearer #{slack_bot_ultron_token()}"}
    #     ]
    #   )

    # IO.inspect(response)
    cmd = ~s(curl -vvv -F "content=#{Poison.Parser.parse!(payload)|> encode_payload()}" -F "title=UltronX FWD msg" -F "inital_comment=#{message}" -F "filename=payload" -F "channels=#{channel}" -H"Content-type:multipart/form-data" -H"Authorization:Bearer xoxb-53586587540-lxYylT8RhBLib1jPM1996KxS" -X POST "https://slack.com/api/files.upload")
    IO.inspect(cmd)
    IO.inspect(cmd|> String.to_char_list|> :os.cmd)
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
