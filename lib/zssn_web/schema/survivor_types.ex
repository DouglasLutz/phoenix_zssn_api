defmodule ZssnWeb.Schema.SurvivorTypes do
  use Absinthe.Schema.Notation

  alias ZssnWeb.Resolvers

  object :survivor_queries do
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
    field :gender, :gender
    field :latitude, :string
    field :longitude, :string
    field :reports, :integer
    field :infected, :boolean
    field :inserted_at, :date
  end

  @desc "Filtering options for the survivors list"
  input_object :survivor_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a gender"
    field :gender, :gender

    @desc "Infected survivors"
    field :infected, :boolean

    @desc "Aged above a value"
    field :aged_above, :integer

    @desc "Aged below a value"
    field :aged_below, :integer

    @desc "Inserted after this date"
    field :inserted_after, :date

    @desc "Inserted before this date"
    field :inserted_before, :date
  end

  @desc "Available options for gender field"
  enum :gender do
    value :male, as: "male"
    value :female, as: "female"
  end
end
