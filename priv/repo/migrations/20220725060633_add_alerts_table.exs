defmodule JohanChallenge.Repo.Migrations.AddAlertsTable do
  use Ecto.Migration

  def change do
    create table("alerts", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :incident_dt, :naive_datetime_usec
      add :value, :string
      add :type, :string
      add :lat, :string
      add :lon, :string
      add :device_id, references(:devices, type: :uuid)
    end

    create index(:alerts, [:incident_dt, :type])
    create index(:alerts, [:incident_dt])
    create index(:alerts, [:type])
  end
end
