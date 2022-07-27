defmodule JohanChallenge.Core.Repositories.CaregiverTest do
  use JohanChallenge.DataCase

  alias JohanChallenge.Core.Repositories.Caregiver, as: CaregiverRepo

  import JohanChallenge.Factory

  setup do
    context = build(:all)
    %{
      patient: context.patient,
      health_center: context.health_center,
      caregiver: context.caregiver
    }
  end

  describe "get_caregiver_to_patient/1" do
    test "find a caregiver by patient_id", context do
      {status, result} = CaregiverRepo.get_caregiver_to_patient(context.patient.id)

      assert status == :ok
      assert result.health_center_id == context.health_center.id
      assert result.id == context.caregiver.id
      assert result.phone_number == context.caregiver.phone_number
    end
  end
end
