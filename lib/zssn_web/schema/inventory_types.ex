defmodule ZssnWeb.Schema.InventoryTypes do
  use Absinthe.Schema.Notation

  alias ZssnWeb.Resolvers

  object :inventory_queries do
    field :survivor_items, list_of(:survivor_item) do
      resolve &Resolvers.Inventories.survivor_items/3
    end
  end

  object :survivor_item do
    field :id, :id
    field :item_id, :id
    field :survivor_id, :id
    field :quantity, :integer
  end
end
