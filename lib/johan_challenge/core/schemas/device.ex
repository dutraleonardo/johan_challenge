defmodule JohanChallenge.Core.Schemas.Device do
  @moduledoc """
  The davice's schema
  """
  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.{Alert, HealthCenter, Patient}

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @required [:sim_sid, :health_center_id, :patient_id]

  schema "devices" do
    field :sim_sid, :string

    belongs_to :health_center, HealthCenter
    belongs_to :patient, Patient

    has_many :alerts, Alert

    timestamps()
  end

  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:patient_id)
    |> foreign_key_constraint(:health_center_id)
  end
end
