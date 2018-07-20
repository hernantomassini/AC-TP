defmodule SubastaAutomaticaTest do
  use ExUnit.Case
  doctest SubastaAutomatica

  ##Nota 0:  SubastaAutomaticaSupervisor.start_link el supervisor inicia el estado del moludo subasta con 0
  ##Nota 1: los test son asincronicos, entonces fallan o no.
  ##Nota 2: todos los test esta compartiendo el estado, eso esta mal, general acoplamiento en los test
  ##Note 3: el estado del test 1 afecta al test 2

  test "  (0 + 10) * 2" do
  
    SubastaAutomatica.suma(10)
    SubastaAutomatica.multiply(2)
    ##SubastaAutomatica.result |> IO.puts
    assert SubastaAutomatica.result == 20.00
  end

  test "Suma que falla debe ser 10 pero es 38, afecta el estado anterior" do
    SubastaAutomatica.suma(10)
    assert SubastaAutomatica.result == 30
  end

  test "Supervisor se reinicia solo despues de un error" do
   
    ##SubastaAutomaticaSupervisor.start_link
    #SubastaAutomatica.suma(10)
    ##SubastaAutomatica.div(0)
    ##SubastaAutomatica.result |> IO.puts
    #assert SubastaAutomatica.result == 0
    
  end


end
