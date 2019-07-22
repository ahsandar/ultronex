defmodule Ultron.Realtime.Respose do
  def event(message, slack) do
    try do
      case Ultron.Realtime.Msg.parse(message |> Map.get(:text) || "") do
        {"fwd", list} ->
          Ultron.Command.Forward.fwd(message, slack, list)

        {"stop", list} ->
          Ultron.Command.Forward.stop(message, slack, list)

        {"giphy", list} ->
          Ultron.Command.Giphy.gif(message, slack, list)

        {"gif", list} ->
          Ultron.Command.Giphy.gif(message, slack, list)

        {"hi", list} ->
          Ultron.Command.Greet.hi(message, slack, list)

        {"hello", list} ->
          Ultron.Command.Greet.hello(message, slack, list)

        {"mute", list} ->
          Ultron.Command.Talk.mute(message, slack, list)

        {"unmute", list} ->
          Ultron.Command.Talk.unmute(message, slack, list)

        {"quote", list} ->
          Ultron.Command.Quote.random(message, slack, list)

        {"xkcd", list} ->
          Ultron.Command.Xkcd.comic(message, slack, list)

        {"help", list} ->
          Ultron.Command.Help.output(message, slack, list)

        {nil, list} ->
          cond do
            Enum.member?(get_channel_list_to_monitor(), message.channel) ->
              Ultron.Command.Parse.msg(message, slack, list)

            true ->
              {:ok, []}
          end

        {_, list} ->
          Ultron.Command.Help.unknown(message, slack, list)
      end
    rescue
      e in RuntimeError -> IO.puts("Wal lao eh - Slack \n" <> e.message)
    end
  end

  def get_channel_list_to_monitor do
    String.split(System.get_env("SLACK_CHANNEL_LIST"), ",")
  end
end
