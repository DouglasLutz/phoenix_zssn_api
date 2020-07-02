defmodule Zssn.Survivors.Survivor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivors" do
    field :age, :integer
    field :gender, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :infected, :boolean
    field :reports, :integer

    has_many :survivor_items, Zssn.Inventories.SurvivorItem

    timestamps()
  end

  @doc false
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, [:name, :gender, :age, :latitude, :longitude, :infected, :reports])
    |> cast_assoc(:survivor_items, with: &Zssn.Inventories.SurvivorItem.changeset/2)
    |> validate_required([:name, :gender, :age, :latitude, :longitude])
  end
end
