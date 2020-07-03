defmodule ZssnWeb.Resolvers.Items do
  import ZssnWeb.Resolvers.Support.ErrorFormat

  alias Zssn.Graphql.Items

  def items(_, args, _) do
    {:ok, Items.list_items(args)}
  end

  def create_item(_, %{input: params}, _) do
    case Items.create_item(params) do
      {:ok, item} ->
        {:ok, %{item: item}}
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end
end
