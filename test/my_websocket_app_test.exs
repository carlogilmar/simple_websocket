defmodule MyWebsocketAppTest do
  use ExUnit.Case
  doctest MyWebsocketApp

  test "greets the world" do
    assert MyWebsocketApp.hello() == :world
  end
end
