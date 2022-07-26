defmodule JohanChallenge.Core.Schemas.AlertAuditTest do
  use JohanChallenge.DataCase, async: true

  alias JohanChallenge.Core.Schemas.AlertAudit

  import JohanChallenge.Factory

  setup do
    alert = insert!(:alert)
    %{alert: alert}
  end

  describe "alerts_audit" do
    @valid_attrs %{
      raw_data: %{
        "DT" => "2015-07-30T20:00:00Z",
        "LAT" => "52.1544408",
        "LON" => "4.2934847",
        "T" => "BPM",
        "VAL" => "200"
      }
    }
    @invalid_attrs %{data: %{"DT" => "2015-07-30T20:00:00Z"}}

    test "changeset/1 with valid data", %{alert: alert} do
      changeset =
        @valid_attrs
        |> Map.put(:alert_id, alert.id)
        |> AlertAudit.changeset()

      assert changeset.valid? == true
      assert changeset.errors == []
      assert changeset.changes.raw_data == @valid_attrs.raw_data
      assert changeset.changes.alert_id == alert.id
    end

    test "changeset/1 with invalid data" do
      changeset = AlertAudit.changeset(@invalid_attrs)
      assert changeset.valid? == false
      assert changeset.errors != []
    end
  end
end
