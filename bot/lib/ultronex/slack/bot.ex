require Logger

defmodule Ultronex.Slack.Bot do
  use Slack

  @moduledoc """
  Documentation for Ultronex.Slack.Bot
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
    Task.async(fn -> TermStorage.ets_incr(:stats, :replied_msg_count) end)
    send_message(message, channel, slack)
  end
end
