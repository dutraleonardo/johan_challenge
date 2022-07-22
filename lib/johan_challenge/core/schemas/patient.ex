defmodule JohanChallenge.Core.Schemas.Patient do
  @moduledoc """
  The patient's schema
  """
  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.{Device, HealthCenter}

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required [:first_name, :last_name, :address, :city, :country, :state, :postal_code, :health_center_id]
  @optional [:additional_info]

  schema "patients" do
    field :first_name, :string
    field :last_name, :string
    field :address, :string
    field :city, :string
    field :country, :string
    field :state, :string
    field :postal_code, :string
    field :additional_info, :string

    belongs_to :health_center, HealthCenter
    has_many :devices, Device

    timestamps()
  end

  @spec changeset(patient :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
