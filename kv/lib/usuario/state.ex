defmodule Usuario.Struct do
  @moduledoc false

  defstruct [:id,:ip,:puerto,:tags]

end

defmodule Usuario.State do

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket) do
    Agent.get(bucket, &Map.get(&1, "state"))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def save(bucket, value) do
    Agent.update(bucket, &Map.put(&1, "state", value))
  end
end
