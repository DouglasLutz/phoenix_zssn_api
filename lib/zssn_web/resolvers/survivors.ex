defmodule ZssnWeb.Resolvers.Survivors do
  alias Zssn.Graphql.Survivors

  def survivors(_, args, _) do
    {:ok, Survivors.list_survivors(args)}
  end
end
