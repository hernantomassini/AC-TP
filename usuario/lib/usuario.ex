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
  def get(instance) do
    Agent.get(instance, &Map.get(&1, "state"))
  end

  @doc """
  Puts the `value` for the given `key` in the `instance`.
  """
  def save(instance, value) do
    Agent.update(instance, &Map.put(&1, "state", value))
  end

  def crear_subasta(instance) do
      body=Poison.encode!(Usuario.get(instance))
     response=Usuario.post("/buyers",body)
     IO.inspect(response)
  end

  def obtener_subasta(instance) do
    body=Poison.encode!(Usuario.get(instance))
    {:ok,Usuario.post("/buyers",body)}
    IO.puts("ejecutado post")
  end




end
