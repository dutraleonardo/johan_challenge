defmodule JohanChallenge.Repo.Migrations.AddFieldInsertedAtAlerts do
  use Ecto.Migration

  def change do
    alter table(:alerts) do
      timestamps()
    end
  end
end
