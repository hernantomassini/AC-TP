defmodule Modelo.Usuario do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:id,:ip,:puerto,:tags]
end

defmodule Usuario do
  @moduledoc false
  use HTTPoison.Base

  @endpoint "http://127.0.0.1:8085"

  def process_url(url) do
    @endpoint <> url
  end

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `instance` by `key`.
  """
  def state(instance) do
    Agent.get(instance, &Map.get(&1, "state"))
  end

  @doc """
  Puts the `value` for the given `key` in the `instance`.
  """
  def save(instance, value) do
    Agent.update(instance, &Map.put(&1, "state", value))
  end




  @doc """
    COMPORTAMIEOT  DE ITERACCION CON SERVIDOR
  """

  def registrar_usuario(instance) do
     body=Poison.encode!(Usuario.state(instance))
     response=Usuario.post("/buyers",body)
     IO.inspect(response)
  end

  def consultar_usuario(instance) do
    usuario=Usuario.state(instance)
    response=Usuario.get("/buyers/" <> usuario.id)
    IO.inspect(response)
  end


  def crear_subasta(instance,subasta) do
    usuario=Usuario.state(instance)
    body=Poison.encode!(%{idUsuario: usuario.id, subasta: subasta})
    Usuario.post("/bids",body)
  end

  def ofertar_subasta(instance,oferta) do
    usuario=Usuario.state(instance)
    body=Poison.encode!(%{idUsuario: usuario.id, oferta: oferta})
    Usuario.put("/bids",body)
  end

  def cancelar_subasta(instance,idSubasta) do
    usuario=Usuario.state(instance)
    Usuario.delete("/bids/" <> usuario.id <> "/" <> idSubasta)
  end






end
