defmodule Zssn.Repo.Migrations.UpdateSurvivorsTable do
  use Ecto.Migration

  def change do
    alter table(:survivors) do
      add :reports, :integer, default: 0
      add :infected, :boolean, default: false
    end
  end
end
