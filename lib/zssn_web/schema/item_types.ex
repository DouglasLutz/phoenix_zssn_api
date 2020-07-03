defmodule ZssnWeb.Schema.ItemTypes do
  use Absinthe.Schema.Notation

  alias ZssnWeb.Resolvers

  object :item_queries do
    field :items, list_of(:item) do
      arg :filter, :item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Items.items/3
    end
  end

  object :item_mutations do
    field :create_item, :item_result do
      arg :input, :item_create_input
      resolve &Resolvers.Items.create_item/3
    end
  end

  @desc "Existing items"
  object :item do
    field :id, :id
    field :name, :string
    field :value, :integer
  end

  object :item_result do
    field :item, :item
    field :errors, list_of(:input_error)
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

  input_object :item_create_input do
    field :name, :string
    field :value, :integer
  end
end
