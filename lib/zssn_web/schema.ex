defmodule ZssnWeb.Schema do
  use Absinthe.Schema

  alias ZssnWeb.Resolvers
  query do
    @desc "The list of survivors in the application"
    field :survivors, list_of(:survivor) do
      arg :filter, :survivor_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Resources.survivors/3
    end
  end

  @desc "A survivor in this big world"
  object :survivor do
    field :id, :id
    field :name, :string
    field :age, :integer
    field :gender, :string
    field :latitude, :string
    field :longitude, :string
    field :reports, :integer
    field :infected, :boolean
  end

  @desc "Filtering options for the survivors list"
  input_object :survivor_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a gender"
    field :gender, :string

    @desc "Infected survivors"
    field :infected, :boolean

    @desc "Aged above a value"
    field :aged_above, :integer

    @desc "Aged below a value"
    field :aged_below, :integer
  end

  enum :sort_order do
    value :asc
    value :desc
  end
end
