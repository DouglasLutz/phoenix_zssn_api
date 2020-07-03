defmodule Zssn.Graphql.Inventories do
  import Ecto.Query, warn: false

  alias Zssn.Repo
  alias Zssn.Inventories.SurvivorItem

  def list_survivor_items(_) do
    Repo.all(SurvivorItem)
  end
end
