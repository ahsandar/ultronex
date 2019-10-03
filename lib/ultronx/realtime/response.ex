defmodule Ultronx.Realtime.Respose do
  def event(message, slack) do
    try do
      case Ultronx.Realtime.Msg.parse(message |> Map.get(:text) || "") do
        {"fwd", list} ->
          Ultronx.Command.Forward.fwd(message, slack, list)

        {"stop", list} ->
          Ultronx.Command.Forward.stop(message, slack, list)

        {"giphy", list} ->
          Ultronx.Command.Giphy.gif(message, slack, list)

        {"gif", list} ->
          Ultronx.Command.Giphy.gif(message, slack, list)

        {"hi", list} ->
          Ultronx.Command.Greet.hi(message, slack, list)

        {"hello", list} ->
          Ultronx.Command.Greet.hello(message, slack, list)

        {"mute", list} ->
          Ultronx.Command.Talk.mute(message, slack, list)

        {"unmute", list} ->
          Ultronx.Command.Talk.unmute(message, slack, list)

        {"quote", list} ->
          Ultronx.Command.Quote.random(message, slack, list)

        {"xkcd", list} ->
          Ultronx.Command.Xkcd.comic(message, slack, list)

        {"help", list} ->
          Ultronx.Command.Help.output(message, slack, list)

        {nil, list} ->
          cond do
            Enum.member?(get_channel_list_to_monitor(), message.channel) ->
              Ultronx.Command.Parse.msg(message, slack, list)

            true ->
              {:ok, []}
          end

        {_, list} ->
          Ultronx.Command.Help.unknown(message, slack, list)
      end
    rescue
      e in RuntimeError -> IO.puts("Wal lao eh - Slack \n" <> e.message)
    end
  end

  def get_channel_list_to_monitor do
    String.split(System.get_env("SLACK_CHANNEL_LIST"), ",")
  end
end
