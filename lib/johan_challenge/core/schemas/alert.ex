defmodule JohanChallenge.Core.Schemas.Alert do
  @moduledoc """
  The alert's schema
  """
  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.{AlertAudit, Device}

  import Ecto.Changeset

  @required [:incident_dt, :value, :type, :lat, :lon, :device_id]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @alert_type [:BPM, :TEMP, :FALL]

  schema "alerts" do
    field :incident_dt, :naive_datetime_usec
    field :value, :string
    field :type, Ecto.Enum, values: @alert_type
    field :lat, :string
    field :lon, :string

    belongs_to :device, Device

    has_one :alert_audit, AlertAudit

    timestamps()
  end

  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:device_id)
  end
end
