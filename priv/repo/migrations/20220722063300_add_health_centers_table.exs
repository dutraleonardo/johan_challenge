defmodule JohanChallenge.Repo.Migrations.AddHealthCentersTable do
  use Ecto.Migration

  def change do
    create table(:health_centers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:health_centers, [:name])
  end
end
