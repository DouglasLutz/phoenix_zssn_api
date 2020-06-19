defmodule Zssn.Repo.Migrations.CreateSurvivorItems do
  use Ecto.Migration

  def change do
    create table(:survivor_items) do
      add :quantity, :integer
      add :survivor_id, references(:survivors, on_delete: :nothing)
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end

    create index(:survivor_items, [:survivor_id])
    create index(:survivor_items, [:item_id])
  end
end
