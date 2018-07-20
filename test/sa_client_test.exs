defmodule SaClientTest do
  use ExUnit.Case
  doctest SaClient

  test "crear una subata" do
    assert SaClient.crear_subasta() == :crear_subasta
  end

  test "participar en las subastas" do
    assert SaClient.participar_en_subasta() == :participar_en_subasta
  end
end
