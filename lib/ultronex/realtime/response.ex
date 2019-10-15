require Logger

defmodule Ultronex.Realtime.Respose do
  def event(message, slack) do
    try do
      case Ultronex.Realtime.Msg.parse(message |> Map.get(:text) || "") do
        {"fwd", list} ->
          Ultronex.Command.Forward.fwd(message, slack, list)

        {"stop", list} ->
          Ultronex.Command.Forward.stop(message, slack, list)

        {"giphy", list} ->
          Ultronex.Command.Giphy.gif(message, slack, list)

        {"gif", list} ->
          Ultronex.Command.Giphy.gif(message, slack, list)

        {"hi", list} ->
          Ultronex.Command.Greet.hi(message, slack, list)

        {"hello", list} ->
          Ultronex.Command.Greet.hello(message, slack, list)

        {"mute", list} ->
          Ultronex.Command.Talk.mute(message, slack, list)

        {"unmute", list} ->
          Ultronex.Command.Talk.unmute(message, slack, list)

        {"quote", list} ->
          Ultronex.Command.Quote.random(message, slack, list)

        {"xkcd", list} ->
          Ultronex.Command.Xkcd.comic(message, slack, list)

        {"help", list} ->
          Ultronex.Command.Help.output(message, slack, list)

        {nil, list} ->
          cond do
            Enum.member?(get_channel_list_to_monitor(), message.channel) ->
              Ultronex.Command.Parse.msg(message, slack, list)

            true ->
              {:ok, []}
          end

        {_, list} ->
          Ultronex.Command.Help.unknown(message, slack, list)
      end
    rescue
      e in RuntimeError -> Logger.info("Wal lao eh - Slack \n" <> e.message)
    end
  end

  def get_channel_list_to_monitor do
    String.split(System.get_env("SLACK_CHANNEL_LIST"), ",")
  end
end
