defmodule JohanChallenge.Core.Schemas.Device do
  @moduledoc """
  The davice's schema
  """
  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.{HealthCenter, Patient}

  import Ecto.Changeset

  @required [:sim_sid, :health_center_id, :patients_id]

  schema "devices" do
    field :sim_sid, :string

    belongs_to :health_center, HealthCenter
    belongs_to :patient, Patient

    timestamps()
  end

  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
