defmodule Zssn.Resources.Survivor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivors" do
    field :age, :integer
    field :gender, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, [:name, :gender, :age, :latitude, :longitude])
    |> validate_required([:name, :gender, :age, :latitude, :longitude])
  end
end
