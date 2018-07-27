defmodule Modelo.Usuario do
  @derive [Poison.Encoder]
  defstruct [:id, :ip, :puerto, :tags]

  # tags es una List, subastas es un MapSet
  def subastas_de_interes(tags, subastas) do
    Enum.filter(subastas, fn s -> length(capitalize_tags(tags) -- capitalize_tags(s.tags)) != length(tags) end)
  end

  defp capitalize_tags(tags) do
    Enum.map(tags, fn t -> String.capitalize(t) end)
  end
end
