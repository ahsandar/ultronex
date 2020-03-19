defmodule Ultronex.Server.Websocket.SocketHandler do
  use Appsignal.Instrumentation.Decorators

  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.UltronexApp
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  @decorate transaction()
  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    message = payload["data"]["message"]
    websocket_send_msg(message, state)
    {:reply, {:text, message}, state}
  end

  @decorate transaction()
  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  @decorate transaction()
  def websocket_send_msg(message, state) do
    Registry.UltronexApp
    |> Registry.dispatch(state.registry_key, fn entries ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)
  end
end
