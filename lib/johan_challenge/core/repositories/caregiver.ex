defmodule JohanChallenge.Core.Repositories.Caregiver do
  @moduledoc """
  Caregiver's repository. This module handle queries to caregivers' table
  """

  alias JohanChallenge.Repo
  alias JohanChallenge.Core.Schemas.{Caregiver, HealthCenter, Patient}
  import Ecto.Query

  def get_caregiver_to_patient(patient_id) do
    case by_patient_id(patient_id) do
      [] ->
        {:error, "Caregiver not found"}

      caregivers ->
        caregiver =
          caregivers
          |> Enum.random()

        {:ok, caregiver}
    end
  end

  defp by_patient_id(patient_id) do
    from(
      patient in Patient,
      inner_join: hc in HealthCenter,
      on: patient.health_center_id == hc.id,
      left_join: caregivers in Caregiver,
      on: caregivers.health_center_id == hc.id,
      where: patient.id == ^patient_id,
      select: caregivers
    )
    |> Repo.all()
  end
end
