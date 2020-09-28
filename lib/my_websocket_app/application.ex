defmodule MyWebsocketApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MyWebsocketApp.Worker.start_link(arg)
      # {MyWebsocketApp.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: MyWebsocketApp.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.MyWebsocketApp
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyWebsocketApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/ws/socketcito", MyWebsocketApp.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {MyWebsocketApp.Router, []}}
        ]
      }
    ]
  end
end
