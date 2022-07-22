defmodule JohanChallenge.Core.Schemas.HealthCenter do
  @moduledoc """
  The health center's schema.
  """

  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.{Caregiver, Patient}

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "health_centers" do
    field :name, :string

    has_many :caregivers, Caregiver
    has_many :patients, Patient

    timestamps()
  end

  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
