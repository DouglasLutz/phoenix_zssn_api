defmodule Zssn.Repo.Migrations.CreateSurvivors do
  use Ecto.Migration

  def change do
    create table(:survivors) do
      add :name, :string
      add :gender, :string
      add :age, :integer
      add :latitude, :decimal
      add :longitude, :decimal

      timestamps()
    end

  end
end
