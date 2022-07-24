defmodule JohanChallenge.Repo.Migrations.AddDevicesTable do
  use Ecto.Migration

  def change do
    create table(:devices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :sim_sid, :string, null: false

      add :patient_id, references(:patients, type: :uuid)
      add :health_center_id, references(:health_centers, type: :uuid)

      timestamps()
    end

    create unique_index(:devices, [:sim_sid])
  end
end
