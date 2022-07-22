defmodule JohanChallenge.Repo.Migrations.AddCaregiversTable do
  use Ecto.Migration

  def change do
    create table(:caregivers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :phone_number, :string

      add :health_center_id,  references(:health_centers, type: :uuid)

      timestamps()
    end

    create unique_index(:caregivers, [:health_center_id, :phone_number])
    create index(:caregivers, [:phone_number])
  end
end
