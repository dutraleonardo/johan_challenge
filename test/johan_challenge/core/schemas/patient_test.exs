defmodule JohanChallenge.Core.Schemas.PatientTest do
  use JohanChallenge.DataCase, async: true

  alias JohanChallenge.Core.Schemas.Patient

  import JohanChallenge.Factory

  setup do
    health_center = insert!(:health_center, %{name: "Health Center Test"})
    %{id: health_center.id, name: health_center.name}
  end

  describe "patients" do
    @valid_attrs %{
      first_name: "John",
      last_name: "Doe",
      address: "Delftechpark 23",
      city: "Delft",
      country: "Netherlands",
      state: "Zuid-Holland",
      postal_code: "01234567-89"
    }
    @additional_info "Patient's address is a house at the end of the street. Please enter through the back door. Patient is hypertension and diabetes."
    @invalid_attrs %{full_name: "John Doe"}

    test "changeset/1 with valid data", health_center do
      changeset =
        @valid_attrs
        |> Map.merge(%{health_center_id: health_center.id, additional_info: @additional_info})
        |> Patient.changeset()

      assert changeset.valid? == true
      assert changeset.errors == []
      assert changeset.changes.first_name == @valid_attrs.first_name
      assert changeset.changes.last_name == @valid_attrs.last_name
      assert changeset.changes.address == @valid_attrs.address
      assert changeset.changes.city == @valid_attrs.city
      assert changeset.changes.country == @valid_attrs.country
      assert changeset.changes.state == @valid_attrs.state
      assert changeset.changes.postal_code == @valid_attrs.postal_code
      assert changeset.changes.additional_info == @additional_info
      assert changeset.changes.health_center_id == health_center.id
    end

    test "changeset/1 with invalid data" do
      changeset = Patient.changeset(@invalid_attrs)
      assert changeset.valid? == false
      assert changeset.errors != []
    end
  end
end
