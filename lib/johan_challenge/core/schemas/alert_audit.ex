defmodule JohanChallenge.Core.Schemas.AlertAudit do
  @moduledoc """
  The alert audit's schema. This schema represents a table that stores raw data from the alert's callback
  """
  use Ecto.Schema

  alias JohanChallenge.Core.Schemas.Alert

  import Ecto.Changeset

  @foreign_key_type Ecto.UUID
  @required [:raw_data, :alert_id]
  schema "alerts_audit" do
    field :raw_data, :map

    belongs_to :alert, Alert

    timestamps()
  end

  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
