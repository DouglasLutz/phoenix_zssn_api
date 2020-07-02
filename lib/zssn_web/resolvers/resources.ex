defmodule ZssnWeb.Resolvers.Resources do
  alias Zssn.Graphql.Resources

  def survivors(_, args, _) do
    {:ok, Resources.list_survivors(args)}
  end
end
