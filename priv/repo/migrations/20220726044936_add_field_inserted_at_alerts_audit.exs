defmodule JohanChallenge.Repo.Migrations.AddFieldInsertedAtAlertsAudit do
  use Ecto.Migration

  def change do
    alter table(:alerts_audit) do
      timestamps()
    end
  end
end
