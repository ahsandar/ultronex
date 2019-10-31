defmodule Ultronex.Command.Secret do
  @moduledoc """
  Documentation for Ultronex.Command.Secret
  """
  alias Ultronex.Command.Help, as: Help
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Realtime.TermStorage, as: TermStorage

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
