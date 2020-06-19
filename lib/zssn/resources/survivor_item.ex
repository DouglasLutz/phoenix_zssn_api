defmodule Zssn.Resources.SurvivorItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivor_items" do
    field :quantity, :integer
    field :survivor_id, :id
    field :item_id, :id

    timestamps()
  end

  @doc false
  def changeset(survivor_item, attrs) do
    survivor_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
