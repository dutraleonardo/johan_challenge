defmodule JohanChallenge.Core.Schemas.Caregiver do
  @moduledoc """
  The caregiver's schema
  """
  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.HealthCenter

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @required [:phone_number, :health_center_id]

  schema "caregivers" do
    field :phone_number, :string

    belongs_to :health_center, HealthCenter

    timestamps()
  end

  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
    |> unique_constraint(:phone_number)
  end
end
