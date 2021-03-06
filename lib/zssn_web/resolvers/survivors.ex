defmodule ZssnWeb.Resolvers.Survivors do

  alias Zssn.Graphql.Survivors
  alias Zssn.Survivors.Survivor

  def survivors(_, args, _) do
    {:ok, Survivors.list_survivors(args)}
  end

  def create_survivor(_, %{input: params}, _) do
    with {:ok, survivor} <- Survivors.create_survivor(params) do
      {:ok, %{survivor: survivor}}
    end
  end

  def update_survivor(_, %{id: id, input: params}, _) do
    with  %Survivor{} = survivor <- Survivors.get_survivor(id),
          {:ok, %Survivor{} = survivor} <- Survivors.update_survivor(survivor, params) do
      {:ok, %{survivor: survivor}}
    else
      nil ->
        {:ok, %{errors: [%{key: :id, message: "Couldn't find survivor"}]}}
    end
  end
end
