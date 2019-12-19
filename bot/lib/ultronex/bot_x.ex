require Logger

defmodule Ultronex.BotX do
  use Slack

  @moduledoc """
  Documentation for Ultronex.BotX
  """

  alias Ultronex.Realtime.Response, as: Response
  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

  def initialize_term_storage do
    Logger.info("Creating Term Storage ...")
    TermStorage.initialize()
  end

  def ets_initialize(table \\ :stats) do
    Logger.info('Initializing :ets : #{table}')
    :ets.insert(table, {:uptime, DateTime.utc_now() |> DateTime.to_string()})
    :ets.insert(table, {:total_msg_count, 0})
    :ets.insert(table, {:replied_msg_count, 0})
    :ets.insert(table, {:forwarded_msg_count, 0})
    :ets.insert(table, {:total_attachments_downloaded, 0})
    :ets.insert(table, {:total_messages_slacked, 0})
  end

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    initialize_term_storage()
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
    TermStorage.ets_tab2file(:track)
    TermStorage.ets_tab2file(:stats)
    extra = reason |> elem(1)
    Utility.send_error_to_sentry("Slack error", extra)
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

  def relay_msg_to_slack(message, payload, channel) do
    response = send_payload_to_slack(message, payload, channel)
    TermStorage.ets_incr(:stats, :total_messages_slacked)
    response
  end


  def send_payload_to_slack(message, payload, channel) do
    url = "https://slack.com/api/files.upload"

    encoded_payload =
      %{
        channels: channel,
        initial_comment: message,
        content: payload,
        title: "UltronEx FWD msg"
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

    spawn(Ultronex.BotX, :check_slack_response, [response])
    response
  end

  def check_slack_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 429, body: body}} ->
        Utility.send_error_to_sentry("Ultronex Rate Limited ", body)

      _ ->
        response
    end
  end
end
