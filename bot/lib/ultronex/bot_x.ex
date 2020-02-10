require Logger

defmodule Ultronex.BotX do
  use Slack

  @moduledoc """
  Documentation for Ultronex.BotX
  """

  alias Ultronex.Realtime.Response, as: Response
  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    Response.event(message, slack)
    TermStorage.ets_incr()
    {:ok, state}
  end

  def handle_event(_message, _slack, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info("Sending your message, captain!")
    send_message(text, channel, slack)
    TermStorage.ets_incr(:stats, :replied_msg_count)
    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

  def handle_close(reason, _slack, _state) do
    extra = reason |> elem(1)
    Utility.log_count(:external, :errors, "Slack error : remote closed")
    Task.async(fn -> Utility.send_error_to_monitor("Slack error : remote closed", extra) end)
  end

  def heartbeat do
    Logger.info("I am alive got heartbeat")
  end

  def send_msg_to_slack(message, channel, slack) do
    send_message(message, channel, slack)
    TermStorage.ets_incr(:stats, :replied_msg_count)
  end

  def post_msg_to_slack(message, payload, channel) do
    response = send_payload_to_slack(message, payload, channel)
    TermStorage.ets_incr(:stats, :replied_msg_count)
    TermStorage.ets_incr(:stats, :forwarded_msg_count)
    response
  end

  def relay_msg_to_slack(message, payload, channel, title) do
    response = send_payload_to_slack(message, payload, channel, title)
    TermStorage.ets_incr(:stats, :total_messages_slacked)
    response
  end

  def send_payload_to_slack(message, payload, channel, title \\ "UltronEx FWD msg") do
    url = "https://slack.com/api/files.upload"

    content = if Kernel.is_bitstring(payload), do: payload, else: Kernel.inspect(payload)

    encoded_payload =
      %{
        channels: channel,
        initial_comment: message,
        content: content,
        title: title
      }
      |> URI.encode_query()

    response =
      HTTPoison.post(
        url,
        encoded_payload,
        [
          {"content-type", "application/x-www-form-urlencoded"},
          {"Authorization", Utility.authorization_token()}
        ]
      )

    Task.async(fn -> Ultronex.BotX.check_slack_response(response, title) end)
    response
  end

  def check_slack_response(response, title) do
    key = "Ultronex Rate Limited #{title}"

    case response do
      {:ok, %HTTPoison.Response{status_code: 429}} ->
        Utility.log_count(:external, :errors, key)

      _ ->
        response
    end
  end
end
