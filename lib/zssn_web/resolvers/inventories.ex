defmodule ZssnWeb.Resolvers.Inventories do
  alias Zssn.Graphql.Inventories

  def survivor_items(_, args, _) do
    {:ok, Inventories.list_survivor_items(args)}
  end

  def inventory_for_survivor(survivor, _, _) do
    query = Ecto.assoc(survivor, :survivor_items)
    {:ok, Zssn.Repo.all(query)}
  end
end
