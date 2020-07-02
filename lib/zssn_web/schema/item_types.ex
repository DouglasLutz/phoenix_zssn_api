defmodule ZssnWeb.Schema.ItemTypes do
  use Absinthe.Schema.Notation

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
