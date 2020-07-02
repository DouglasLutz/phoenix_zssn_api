defmodule ZssnWeb.Resolvers.Resources do
  alias Zssn.Graphql.Resources
  alias Zssn.Resources.{Survivor, Item}

  def survivors(_, args, _) do
    {:ok, Resources.list(Survivor, args)}
  end

  def items(_, args, _) do
    {:ok, Resources.list(Item, args)}
  end
end
