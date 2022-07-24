defmodule JohanChallenge.Repo.Migrations.AddPatientsTable do
  use Ecto.Migration

  def change do
    create table(:patients, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :address, :string, null: false
      add :city, :string, null: false
      add :country, :string, null: false
      add :state, :string, null: false
      add :postal_code, :string, null: false
      add :additional_info, :text

      add :health_center_id, references(:health_centers, type: :uuid)

      timestamps()
    end

    create unique_index(:patients, [:first_name, :last_name, :health_center_id])
  end
end
