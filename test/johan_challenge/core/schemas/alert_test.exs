defmodule JohanChallenge.Core.Schemas.AlertTest do
  use JohanChallenge.DataCase, async: true

  alias JohanChallenge.Core.Schemas.Alert

  import JohanChallenge.Factory

  setup do
    device = insert!(:device)
    %{device: device}
  end

  describe "alerts" do
    @valid_attrs %{
      incident_dt: NaiveDateTime.utc_now(),
      value: "200",
      type: "FALL",
      lat: "52.1544408",
      lon: "4.2934847"
    }
    @invalid_attrs %{latitude: "52.1544408", longitude: "4.2934847"}

    test "changeset/1 with valid data", %{device: device} do
      changeset =
        @valid_attrs
        |> Map.put(:device_id, device.id)
        |> Alert.changeset()

      assert changeset.valid? == true
      assert changeset.errors == []
      assert changeset.changes.incident_dt == @valid_attrs.incident_dt
      assert changeset.changes.value == @valid_attrs.value
      assert changeset.changes.type == String.to_atom(@valid_attrs.type)
      assert changeset.changes.lat == @valid_attrs.lat
      assert changeset.changes.lon == @valid_attrs.lon
      assert changeset.changes.device_id == device.id
    end

    test "changeset/1 with invalid data" do
      changeset = Alert.changeset(@invalid_attrs)
      assert changeset.valid? == false
      assert changeset.errors != []
    end
  end
end
