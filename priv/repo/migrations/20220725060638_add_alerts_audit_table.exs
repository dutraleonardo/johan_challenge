defmodule JohanChallenge.Repo.Migrations.AddAlertsAuditTable do
  use Ecto.Migration

  def change do
    create table("alerts_audit") do
      add :raw_data, :map
      add :alert_id, references(:alerts, type: :uuid)
    end

    create index(:alerts_audit, [:alert_id])
  end
end
