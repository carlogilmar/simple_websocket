defmodule MyWebsocketApp.SocketHandler do
  @behaviour :cowboy_websocket

	def send_message(message) do
    Registry.MyWebsocketApp
    |> Registry.dispatch("/ws/socketcito", fn(entries) ->
      for {pid, _} <- entries do
			Process.send(pid, message, [])
      end
    end)
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

  def websocket_info(info, state) do
		IO.puts "2======= Websocket info Replying..."
		IO.inspect state
    {:reply, {:text, info}, state}
  end
end
