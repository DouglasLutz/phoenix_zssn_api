defmodule ZssnWeb.Resolvers.Items do
  alias Zssn.Graphql.Items

  def items(_, args, _) do
    {:ok, Items.list_items(args)}
  end
end
