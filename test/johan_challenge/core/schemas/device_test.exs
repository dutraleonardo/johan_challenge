defmodule JohanChallenge.Core.Schemas.DeviceTest do
  use JohanChallenge.DataCase, async: true

  alias JohanChallenge.Core.Schemas.Device

  import JohanChallenge.Factory

  setup do
    health_center = insert!(:health_center, %{name: "Health Center Test"})

    patient =
      insert!(
        :patient,
        %{
          first_name: "John",
          last_name: "Doe",
          address: "Delftechpark 23",
          city: "Delft",
          country: "Netherlands",
          state: "Zuid-Holland",
          postal_code: "01234567-89"
        }
      )

    %{health_center: health_center, patient: patient}
  end

  describe "devices" do
    @valid_attrs %{sim_sid: Ecto.UUID.autogenerate()}
    @invalid_attrs %{sid: Ecto.UUID.autogenerate()}

    test "changeset/1 with valid data", data do
      changeset =
        @valid_attrs
        |> Map.merge(%{health_center_id: data.health_center.id, patient_id: data.patient.id})
        |> Device.changeset()

      assert changeset.valid? == true
      assert changeset.errors == []
      assert changeset.changes.sim_sid == @valid_attrs.sim_sid
      assert changeset.changes.health_center_id == data.health_center.id
      assert changeset.changes.patient_id == data.patient.id
    end

    test "changeset/1 with invalid data" do
      changeset = Device.changeset(@invalid_attrs)
      assert changeset.valid? == false
      assert changeset.errors != []
    end
  end
end
