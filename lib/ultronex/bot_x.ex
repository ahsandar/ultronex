defmodule Ultronex.BotX do
  use Slack

  @moduledoc """
  Documentation for Ultronex.BotX.
  """

  def initialize_term_storage do
    IO.puts("Creating Term Storage ...")
    Ultronex.Realtime.TermStorage.initialize()
    dets_initialize()
  end

  def dets_initialize(table \\ :slack_count) do
    :dets.insert(table, {:uptime, DateTime.utc_now()|> DateTime.to_string})
    :dets.insert(table, {:total_msg_count, 0})
    :dets.insert(table, {:replied_msg_count, 0})
    :dets.insert(table, {:forwarded_msg_count, 0})
    :dets.insert(table, {:total_attachments_downloaded, 0})
  end

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    initialize_term_storage()
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    Ultronex.Realtime.Respose.event(message, slack)
    Ultronex.Realtime.TermStorage.dets_incr()
    {:ok, state}
  end

  def handle_event(_message, _slack, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")
    send_message(text, channel, slack)
    Ultronex.Realtime.TermStorage.dets_incr(:slack_count, :replied_msg_count)
    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

  def heartbeat do
    IO.puts("I am alive got heartbeat")
  end

  def send_msg_to_slack(message, channel, slack) do
    send_message(message, channel, slack)
    Ultronex.Realtime.TermStorage.dets_incr(:slack_count, :replied_msg_count)
  end

  def post_msg_to_slack(message, payload, channel) do
    url = "https://slack.com/api/files.upload"

    encoded_payload =
      %{
        channels: channel,
        initial_comment: message,
        content: payload,
        title: "UltronEx FWD msg"
      }
      |> URI.encode_query()

    HTTPoison.post(
      url,
      encoded_payload,
      [
        {"content-type", "application/x-www-form-urlencoded"},
        {"Authorization", Ultronex.Utility.authorization_token()}
      ]
    )

    Ultronex.Realtime.TermStorage.dets_incr(:slack_count, :replied_msg_count)
    Ultronex.Realtime.TermStorage.dets_incr(:slack_count, :forwarded_msg_count)
  end

  def terminate(_reason, _state) do
    IO.puts("Terminating slack bot") 
    Ultronex.Realtime.TermStorage.dets_close()
    IO.puts(":dets closed") 
  end
end
