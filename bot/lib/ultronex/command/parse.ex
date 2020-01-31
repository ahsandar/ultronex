require Logger

defmodule Ultronex.Command.Parse do
  @moduledoc """
  Documentation for Ultronex.Command.Parse
  """

  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage
  alias Ultronex.Utility, as: Utility

  def execute(slack_message, slack_state, msg_list) do
    Logger.info("Ultronex.Command.Parse")
    msg(slack_message, slack_state, msg_list)
  end

  def msg(slack_message, _slack_state, _msg_list) do
    Logger.info("Ultronex.Command.Parse.msg")
    pattern_list = :ets.lookup(:track, "pattern")
    text = slack_message |> Map.get(:text) |> to_string()
    attachment = payload(slack_message)
    Logger.info("#{slack_message.user}: #{text}")
    match_pattern_list(pattern_list, text, attachment)
  end

  def match_pattern_list(pattern_list, text, attachment) do
    Enum.each(pattern_list, fn pattern ->
      match = pattern |> elem(1)
      match_msg(match, text, attachment)
    end)
  end

  def match_msg(match, text, attachment) do
    regex_exp = ~r/.*#{match}.*/
    text_match = text |> String.match?(regex_exp)
    attachment_match = attachment |> String.match?(regex_exp)

    if text_match || attachment_match do
      user_list = :ets.lookup(:track, match)
      msg = " `UltronEx` found a match for `#{match}`\n #{text}"
      Logger.info(msg)
      match_user_list(user_list, msg, attachment)
    end
  end

  def match_user_list(user_list, msg, attachment) do
    Enum.each(user_list, fn user_map ->
      user = user_map |> elem(1)
      Msg.post(msg, attachment, "#{user}")
    end)
  end

  def payload(slack_message) do
    Logger.info("Ultronex.Command.Parse.payload")
    files = slack_message |> Map.get(:files)

    if files && files |> List.last() do
      url = files |> List.last() |> Map.get(:url_private_download)
      get_attachment(url)
    else
      "No files attachemnt to download by UltronEx"
    end
  end

  def get_attachment(url) do
    {:ok, response} = get_request(url)

    if response.status == 200 do
      TermStorage.ets_incr(:stats, :total_attachments_downloaded)
      response.body
    else
      raise("Download failed")
    end
  end

  def get_request(url) do
    Tesla.get(Utility.tesla_get_authorized_client(), url)
  end
end
