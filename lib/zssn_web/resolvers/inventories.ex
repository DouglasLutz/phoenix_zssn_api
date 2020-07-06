defmodule ZssnWeb.Resolvers.Inventories do
  alias Zssn.Graphql.Inventories

  def survivor_items(_, args, _) do
    {:ok, Inventories.list_survivor_items(args)}
  end

  def inventory_for_survivor(survivor, _, _) do
    query = Ecto.assoc(survivor, :survivor_items)
    {:ok, Zssn.Repo.all(query)}
  end

  def trade_items(_, %{input: params}, _) do
    case Zssn.Graphql.Inventories.trade_items(params) do
      {:ok, message} ->
        {:ok, %{message: message}}
      {:error, message} ->
        {:error, %{message: message}}
    end
  end
end
