defmodule Ultronex.Command.Secret do
  @moduledoc """
  Documentation for Ultronex.Command.Secret
  """
  alias Ultronex.Command.Help, as: Help
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage

  def avengers_assemble(cmd, message, slack) do
    case cmd do
      {secret_cmd, list} ->
        secret_weapon = Application.fetch_env!(:ultronex, :secret_weapon)

        if secret_cmd == secret_weapon,
          do: secret_activated(message, slack),
          else: Help.unknown(message, slack, list)
    end
  end

  def secret_activated(message, slack) do
    TermStorage.ets_tabs2file([:track, :stats, :external])
    msg = " <@#{message.user}>! Activated, you came for help to `UltronEx`"
    Msg.send(msg, message.channel, slack)
  end
end
