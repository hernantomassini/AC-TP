defmodule SaServerTest do
  use ExUnit.Case
  doctest SaServer

  test "greets the world" do
    assert SaServer.hello() == :world
  end
end
