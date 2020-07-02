defmodule ZssnWeb.Resolvers.Survivors do
  alias Zssn.Graphql.Survivors
  alias Zssn.Survivors.Survivor

  def survivors(_, args, _) do
    {:ok, Survivors.list(Survivor, args)}
  end
end
