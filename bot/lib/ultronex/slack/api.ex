require Logger

defmodule Ultronex.Slack.Api do
  @moduledoc """
  Documentation for Ultronex.Slack.Api
  """

  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

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

  defp send_payload_to_slack(message, payload, channel, title \\ "UltronEx FWD msg") do
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

    response = post_to_slack_via_api(url, encoded_payload)

    Task.async(fn -> Ultronex.Slack.Api.check_slack_response(response, title) end)
    response
  end

  defp post_to_slack_via_api(url, encoded_payload) do
    HTTPoison.post(
      url,
      encoded_payload,
      [
        {"content-type", "application/x-www-form-urlencoded"},
        {"Authorization", Utility.authorization_token()}
      ]
    )
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
