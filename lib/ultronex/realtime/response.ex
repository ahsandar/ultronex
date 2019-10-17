require Logger

defmodule Ultronex.Realtime.Response do
  @moduledoc """
  Documentation for Ultronex.Command.Forward
  """
  alias Ultronex.Command.Forward, as: Forward
  alias Ultronex.Command.Giphy, as: Giphy
  alias Ultronex.Command.Greet, as: Greet
  alias Ultronex.Command.Talk, as: Talk
  alias Ultronex.Command.Quote, as: Quote
  alias Ultronex.Command.Xkcd, as: Xkcd
  alias Ultronex.Command.Parse, as: Parse
  alias Ultronex.Command.Help, as: Help
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage

  def event(message, slack) do
    cmd = Msg.parse(message |> Map.get(:text) || "")

    try do
      case cmd do
        {"fwd", list} ->
          Forward.fwd(message, slack, list)

        {"stop", list} ->
          Forward.stop(message, slack, list)

        {"giphy", list} ->
          Giphy.gif(message, slack, list)

        {"gif", list} ->
          Giphy.gif(message, slack, list)

        {"hi", list} ->
          Greet.hi(message, slack, list)

        {"hello", list} ->
          Greet.hello(message, slack, list)

        {"mute", list} ->
          Talk.mute(message, slack, list)

        {"unmute", list} ->
          Talk.unmute(message, slack, list)

        {"quote", list} ->
          Quote.random(message, slack, list)

        {"xkcd", list} ->
          Xkcd.comic(message, slack, list)

        {"help", list} ->
          Help.output(message, slack, list)

        {nil, list} ->
          if Enum.member?(get_channel_list_to_monitor(), message.channel) do
            Parse.msg(message, slack, list)
          else
            {:ok, []}
          end

        {_, list} ->
          secret_cmd = cmd |> elem(0)
          secret_weapon = System.get_env("SECRET_WEAPON")

          if secret_cmd == secret_weapon do
            secret_activated(message, slack)
          else
            Help.unknown(message, slack, list)
          end
      end
    rescue
      e in RuntimeError -> Logger.info("Wal lao eh - Slack \n" <> e.message)
    end
  end

  def get_channel_list_to_monitor() do
    String.split(System.get_env("SLACK_CHANNEL_LIST"), ",")
  end

  def secret_activated(message, slack) do
    TermStorage.ets_tab2file(:track)
    TermStorage.ets_tab2file(:stats)
    msg = " <@#{message.user}>! Activated, you came for help to `UltronEx`"
    Msg.send(msg, message.channel, slack)
  end
end
