require Logger

defmodule Ultronex.Command.Talk do
  def mute(_slack_message, _slack_state, _msg_list) do
    # TODO imlpement later
    Logger.info("Ultronex.Command.Talk.mute")
  end

  def unmute(_slack_message, _slack_state, _msg_list) do
    # TODO imlpement later
    Logger.info("Ultronex.Command.Talk.unmute")
  end
end
