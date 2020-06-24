defmodule Zssn.Resources.SurvivorItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivor_items" do
    field :quantity, :integer

    belongs_to :survivor, Zssn.Resources.Survivor
    belongs_to :item, Zssn.Resources.Item

    timestamps()
  end

  @doc false
  def changeset(survivor_item, attrs) do
    survivor_item
    |> cast(attrs, [:quantity, :item_id, :survivor_id])
    |> validate_required([:quantity])
    |> foreign_key_constraint(:item_id)
    |> foreign_key_constraint(:survivor_id)
  end
end
