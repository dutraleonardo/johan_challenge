defmodule JohanChallenge.Core.Repositories.AlertTest do
  use JohanChallenge.DataCase

  alias JohanChallenge.Core.Repositories.Alert, as: AlertRepo
  alias JohanChallenge.Repo

  import JohanChallenge.Factory

  @alert_valid_attrs %{
    incident_dt: "2015-07-30T20:00:00Z",
    value: "200",
    type: "FALL",
    lat: "52.1544408",
    lon: "4.2934847"
  }

  @alert_audit_valid_attrs %{
    raw_data: %{
      "DT" => "2015-07-30T20:00:00Z",
      "LAT" => "52.1544408",
      "LON" => "4.2934847",
      "T" => "FALL",
      "VAL" => "200"
    }
  }

  setup do
    device = build(:device)
    device |> Repo.insert!()
    %{device: device}
  end

  describe "insert_alert/1" do
    test "create a new alert with success", %{device: device} do
      {:ok, result} =
        @alert_valid_attrs
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert()

      assert result.id
      assert result.value == @alert_valid_attrs.value
      assert result.type == String.to_atom(@alert_valid_attrs.type)
      assert result.lat == @alert_valid_attrs.lat
      assert result.lon == @alert_valid_attrs.lon
      assert result.device_id == device.id
    end

    test "failed to insert an alert without a device" do
      {status, result} =
        @alert_valid_attrs
        |> AlertRepo.insert_alert()

      assert status == :error
      assert String.contains?(result, "device_id")
    end

    test "failed to insert an alert with invalid attributes", %{device: device} do
      {status, result} =
        @alert_valid_attrs
        |> Map.put(:device_id, device.id)
        |> Map.delete(:type)
        |> AlertRepo.insert_alert()

      assert status == :error
      assert String.contains?(result, "type")
    end
  end

  describe "insert_alert_audit/1" do
    test "create new alert audit", %{device: device} do
      {:ok, %{id: alert_id}} =
        @alert_valid_attrs
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert()

      {status, result} =
        @alert_audit_valid_attrs
        |> Map.put(:alert_id, alert_id)
        |> AlertRepo.insert_alert_audit()

      assert status == :ok
      assert result.id
      assert result.raw_data["DT"] == @alert_valid_attrs.incident_dt
      assert result.raw_data["VAL"] == @alert_valid_attrs.value
      assert result.raw_data["T"] == @alert_valid_attrs.type
      assert result.raw_data["LAT"] == @alert_valid_attrs.lat
      assert result.raw_data["LON"] == @alert_valid_attrs.lon
    end

    test "failed to create a, alert audit without an alert assoc" do
      {status, result} =
        @alert_audit_valid_attrs
        |> AlertRepo.insert_alert_audit()

      assert status == :error
      assert String.contains?(result, "alert_id")
    end
  end

  describe "insert_alert_with_audit/1" do
    test "create an alert and alert audit", %{device: device} do
      {status, result} =
        @alert_valid_attrs
        |> Map.merge(@alert_audit_valid_attrs)
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert_with_audit()

      assert status == :ok
      assert result.id
      assert result.alert_audit.id
    end

    test "failed to create an alert without alert audit", %{device: device} do
      {status, result} =
        @alert_valid_attrs
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert_with_audit()

      assert status == :error
      assert String.contains?(result, "raw_data")
    end

    test "failed to create an alert audit without alert", %{device: device} do
      {status, result} =
        @alert_audit_valid_attrs
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert_with_audit()

      assert status == :error
      assert String.contains?(result, "incident_dt")
      assert String.contains?(result, "value")
      assert String.contains?(result, "type")
    end
  end

  describe "get_by_id/1" do
    test "find an alert using id", %{device: device} do
      {:ok, %{id: alert_id}} =
        @alert_valid_attrs
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert()

      result = AlertRepo.get_by_id(alert_id)

      assert result.id
      assert result.value == @alert_valid_attrs.value
      assert result.type == String.to_atom(@alert_valid_attrs.type)
      assert result.lat == @alert_valid_attrs.lat
      assert result.lon == @alert_valid_attrs.lon
      assert result.device_id == device.id
    end

    test "return nil if don't find an alert" do
      result =
        Ecto.UUID.generate()
        |> AlertRepo.get_by_id()

      assert is_nil(result)
    end
  end

  describe "get_full_alert_by_id/1" do
    test "get alert and alert audit by alert id", %{device: device} do
      {:ok, %{id: alert_id}} =
        @alert_valid_attrs
        |> Map.merge(@alert_audit_valid_attrs)
        |> Map.put(:device_id, device.id)
        |> AlertRepo.insert_alert_with_audit()

      {status, result} = AlertRepo.get_full_alert_by_id(alert_id)

      assert status == :ok
      assert result.id
      assert result.alert_audit.id
      assert result.device_id
    end

    test "error while trying to find a alert that doesnt exist" do
      {status, result} =
        Ecto.UUID.generate()
        |> AlertRepo.get_full_alert_by_id()

      assert status == :error
      assert result == "Alert not found"
    end
  end
end
