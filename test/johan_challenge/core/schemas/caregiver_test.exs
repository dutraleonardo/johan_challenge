defmodule JohanChallenge.Core.Schemas.CaregiverTest do
  use JohanChallenge.DataCase, async: true

  alias JohanChallenge.Core.Schemas.Caregiver

  import JohanChallenge.Factory

  setup do
    health_center = insert!(:health_center, %{name: "Health Center Test"})
    %{id: health_center.id, name: health_center.name}
  end

  describe "caregivers" do
    @valid_attrs %{phone_number: "+5511999887654"}
    @invalid_attrs %{full_name: "Nurse Joy", phone_number: 9_977_665_544}

    test "changeset/1 with valid data", health_center do
      changeset =
        @valid_attrs
        |> Map.put(:health_center_id, health_center.id)
        |> Caregiver.changeset()

      assert changeset.valid? == true
      assert changeset.errors == []
      assert changeset.changes.phone_number == @valid_attrs.phone_number
      assert changeset.changes.health_center_id == health_center.id
    end

    test "changeset/1 with invalid data" do
      changeset = Caregiver.changeset(@invalid_attrs)
      assert changeset.valid? == false
      assert length(changeset.errors) == 2
    end
  end
end
