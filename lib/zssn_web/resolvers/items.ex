defmodule ZssnWeb.Resolvers.Items do
  alias Zssn.Graphql.Items
  alias Zssn.Items.Item

  def items(_, args, _) do
    {:ok, Items.list(Item, args)}
  end
end
