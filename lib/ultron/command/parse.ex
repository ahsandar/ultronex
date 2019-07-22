defmodule Ultron.Command.Parse do
  def msg(slack_message, slack_state, msg_list) do
    IO.puts("Ultron.Command.Parse.msg")
    pattern_list = :ets.lookup(:track, "pattern")

    Enum.each(pattern_list, fn pattern ->
      match = pattern |> elem(1)
      text = slack_message |> Map.get(:text) |> to_string()
      text_match = text |> String.contains?(match)
      attachment = payload(slack_message)
      attachment_match = attachment |> String.contains?(match)

      if text_match || attachment_match do
        IO.puts("Found a match to forward")
        user_list = :ets.lookup(:track, match)

        Enum.each(user_list, fn user_map ->
          user = user_map |> elem(1)

          Ultron.Realtime.Msg.post(
            " `UltronX` found a match for `#{match}`\n #{text}",
            attachment,
            "#{user}",
            slack_state
          )
        end)
      end
    end)
  end

  def payload(slack_message) do
    IO.puts("Ultron.Command.Parse.payload")
    files = slack_message |> Map.get(:files)

    if files && files |> List.last() do
      url = files |> List.last() |> Map.get(:url_private_download)
      get_attachment(url)
    else
      "No files attachemnt to download by UltronX"
    end
  end

  def get_attachment(url) do
    {:ok, response} = get_request(url)

    cond do
      response.status == 200 ->
        response.body

      true ->
        raise("Download failed")
    end
  end

  def slack_bot_ultron_token do
    System.get_env("SLACK_BOT_ULTRON")
  end

  def get_request(url) do
    Tesla.get(tesla_client(), url)
  end

  def tesla_client do
    middleware = [
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{slack_bot_ultron_token()}"}]}
    ]

    Tesla.client(middleware)
  end
end
