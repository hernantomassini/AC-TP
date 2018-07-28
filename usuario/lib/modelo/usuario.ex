defmodule Modelo.Usuario do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:id,:ip,:puerto,:tags]

  def new(id,tags) do
    %Modelo.Usuario{id: id,tags: tags, ip: GlobalContext.get_ip(), puerto: GlobalContext.get_port()}
  end

end