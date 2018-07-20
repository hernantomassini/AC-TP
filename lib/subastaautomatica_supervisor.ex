defmodule SubastaAutomaticaSupervisor do
    use Supervisor
   
    ##función para iniciar el supervisor real
    def start_link do
      Supervisor.start_link(__MODULE__, nil) 
    end
   
    def init(_) do
      supervise(
        [ worker(SubastaAutomatica, [0]) ],
        strategy: :one_for_one
      )
      ##Notas:
      ##1) [0] === CalcServer.start_link(0)
      ##2)  se especifica al SubastaAutomatica  como proceso de trabajo
      ##3) one_for_one: establece que cuando un proceso secundario termina, se debe iniciar uno nuevo.
    end
  end


