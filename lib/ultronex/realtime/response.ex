require Logger

defmodule Ultronex.Realtime.Response do
  @moduledoc """
  Documentation for Ultronex.Realtime.Response
  """

  alias Ultronex.Command.Help, as: Help
  alias Ultronex.Command.Parse, as: Parse
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage

  @response_map %{
    "fwd" => %{:module => Ultronex.Command.Forward, :method => :fwd},
    "stop" => %{:module => Ultronex.Command.Forward, :method => :stop},
    "giphy" => %{:module => Ultronex.Command.Giphy, :method => :gif},
    "gif" => %{:module => Ultronex.Command.Giphy, :method => :gif},
    "hi" => %{:module => Ultronex.Command.Greet, :method => :hi},
    "hello" => %{:module => Ultronex.Command.Greet, :method => :hello},
    "quote" => %{:module => Ultronex.Command.Quote, :method => :random},
    "xkcd" => %{:module => Ultronex.Command.Xkcd, :method => :comic},
    "help" => %{:module => Ultronex.Command.Help, :method => :output}
  }

  def event(message, slack) do
    cmd = Msg.parse(message |> Map.get(:text) || "")

    try do
      case cmd do
        {op, list} ->
          if is_nil(op) do
            silence_is_deafening(message, slack, list)
          else
            fulfill_that_imperative(cmd, message, slack)
          end
      end
    rescue
      e in RuntimeError -> Logger.error("Wal lao eh - Slack \n" <> e.message)
    end
  end

  def fulfill_that_imperative(cmd, message, slack) do
    op = cmd |> elem(0)
    list = cmd |> elem(1)
    module_method_map = @response_map[op]

    if is_nil(module_method_map) do
      avengers_assemble(cmd, message, slack)
    else
      apply(module_method_map[:module], module_method_map[:method], [message, slack, list])
    end
  end

  def get_channel_list_to_monitor do
    Application.fetch_env!(:ultronex, :slack_channel_list) |> String.split(",")
  end

  def silence_is_deafening(message, slack, list) do
    if Enum.member?(get_channel_list_to_monitor(), message.channel) do
      Parse.msg(message, slack, list)
    else
      {:ok, []}
    end
  end

  def avengers_assemble(cmd, message, slack) do
    secret_cmd = cmd |> elem(0)
    list = cmd |> elem(1)
    secret_weapon = Application.fetch_env!(:ultronex, :secret_weapon)

    if secret_cmd == secret_weapon do
      secret_activated(message, slack)
    else
      Help.unknown(message, slack, list)
    end
  end

  def secret_activated(message, slack) do
    TermStorage.ets_tab2file(:track)
    TermStorage.ets_tab2file(:stats)
    msg = " <@#{message.user}>! Activated, you came for help to `UltronEx`"
    Msg.send(msg, message.channel, slack)
  end
end
