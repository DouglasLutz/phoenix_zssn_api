defmodule ZssnWeb.Resolvers.Items do

  alias Zssn.Graphql.Items

  def items(_, args, _) do
    {:ok, Items.list_items(args)}
  end

  def create_item(_, %{input: params}, _) do
    with {:ok, item} <- Items.create_item(params) do
      {:ok, %{item: item}}
    end
  end
end
