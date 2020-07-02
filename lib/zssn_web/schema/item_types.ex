defmodule ZssnWeb.Schema.ItemTypes do
  use Absinthe.Schema.Notation

  alias ZssnWeb.Resolvers

  object :item_queries do
    field :items, list_of(:item) do
      arg :filter, :item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Resources.items/3
    end
  end

  @desc "Existing items"
  object :item do
    field :id, :id
    field :name, :string
    field :value, :integer
  end

  @desc "Filtering options for the items list"
  input_object :item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Value above a number"
    field :valued_above, :integer

    @desc "Value below a value"
    field :valued_below, :integer
  end
end
