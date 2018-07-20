defmodule SubastaAutomaticaTest do
  use ExUnit.Case
  doctest SubastaAutomatica

  test "Raiz de 100" do

    SubastaAutomatica.start(100)
    SubastaAutomatica.sqrt
    assert SubastaAutomatica.result == 10
  end
  test "Raiz de 100 *2 + 8" do

    SubastaAutomatica.start(100)
    SubastaAutomatica.sqrt
    assert SubastaAutomatica.result == 10
    SubastaAutomatica.multiply(2)
    SubastaAutomatica.suma(8)
    ##CalcServer.result |> IO.puts

    assert SubastaAutomatica.result == 28.00
  end
end
