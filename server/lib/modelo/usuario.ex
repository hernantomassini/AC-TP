defmodule Modelo.Usuario do
  @derive [Poison.Encoder]
  defstruct [:id, :ip, :puerto, :tags]

  # tags es una List, subastas es un List
  def subastas_de_interes(tags, subastas) do
    Enum.filter(subastas, fn s -> length(downcase_tags(tags) -- downcase_tags(s.tags)) != length(tags) end)
  end

  def compare_id(id1, id2) do
    String.downcase(id1) === String.downcase(id2)
  end

  defp downcase_tags(tags) do
    Enum.map(tags, fn t -> String.downcase(t) end)
  end

end
