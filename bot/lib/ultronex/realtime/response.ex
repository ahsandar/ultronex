require Logger

defmodule Ultronex.Realtime.Response do
  @moduledoc """
  Documentation for Ultronex.Realtime.Response
  """

  alias Ultronex.Command.Parse, as: Parse
  alias Ultronex.Command.Secret, as: Secret
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Utility, as: Utility

  @command_list %{
    "forward" => :ok,
    "stop" => :ok,
    "gif" => :ok,
    "help" => :ok,
    "quote" => :ok,
    "xkcd" => :ok,
    "talk" => :to_do,
    "mute" => :to_do,
    "secret" => :internal,
    "parse" => :internal
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
    case cmd do
      {module, list} ->
        if @command_list[module] == :ok do
          Utility.get_module_atom(module) |> apply(:execute, [message, slack, list])
        else
          Logger.error("Shiok Avengers Assemble")
          Secret.avengers_assemble(cmd, message, slack)
        end
    end
  end

  def silence_is_deafening(message, slack, list) do
    if Enum.member?(Utility.get_channel_list_to_monitor(), message.channel) do
      Parse.msg(message, slack, list)
    else
      {:ok, []}
    end
  end
end
