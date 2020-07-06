defmodule ZssnWeb.Schema.InventoryTypes do
  use Absinthe.Schema.Notation

  alias ZssnWeb.Resolvers

  object :inventory_queries do
    field :survivor_items, list_of(:survivor_item) do
      resolve &Resolvers.Inventories.survivor_items/3
    end
  end

  object :inventory_mutations do
    @desc "Trade items between survivors"
    field :trade_items, :trade_result do
      arg :input, non_null(:trade_input)
      resolve &Resolvers.Inventories.trade_items/3
    end
  end

  object :survivor_item do
    field :id, :id
    field :item_id, :id
    field :survivor_id, :id
    field :quantity, :integer
  end

  object :trade_result do
    field :message, :string
  end

  input_object :trade_input do
    field :first_trade_items, list_of(:survivor_item_input)
    field :second_trade_items, list_of(:survivor_item_input)
  end

  input_object :survivor_item_input do
    field :item_id, :id
    field :survivor_id, :id
    field :quantity, :integer
  end
end
