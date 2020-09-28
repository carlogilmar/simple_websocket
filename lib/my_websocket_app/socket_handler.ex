defmodule MyWebsocketApp.SocketHandler do
  @behaviour :cowboy_websocket

	def send_message(message) do
		Process.send(self(), message, [])
	end

  def init(request, _state) do
		IO.inspect request
    state = %{registry_key: request.path}
		IO.puts "init socket"

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
		IO.puts "Init websocket..."
    Registry.MyWebsocketApp
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
		IO.puts "1======= Handle websocket"
		IO.inspect json
		IO.inspect state
    payload = Jason.decode!(json)
    message = payload["data"]["message"]

    Registry.MyWebsocketApp
    |> Registry.dispatch(state.registry_key, fn(entries) ->
			IO.inspect entries
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)
		#### For send from iex
		# for {pid, _} <- entries, do: Process.send(pid, "Hola desde la iEx perritos", [])

    {:reply, {:text, message}, state}
  end

  def websocket_info(info, state) do
		IO.puts "2======= Websocket info Replying..."
		IO.inspect state
    {:reply, {:text, info}, state}
  end
end
