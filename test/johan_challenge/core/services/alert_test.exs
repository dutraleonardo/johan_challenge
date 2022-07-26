defmodule JohanChallenge.Core.Services.AlertTest do
  use JohanChallenge.DataCase

  alias JohanChallenge.Core.Services.Alert, as: AlertService

  @valid_attr %{
    "status" => "received",
    "api_version" => "v1",
    "sim_sid" => "HSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
    "content" => "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847",
    "direction" => "from_sim"
  }

  describe "parse_data/1" do
    test "parse string input to map" do
      result =
        @valid_attr
        |> AlertService.parse_data()

      assert result.raw_data
      assert result.incident_dt == result.raw_data["DT"]
      assert result.value == result.raw_data["VAL"]
      assert result.type == result.raw_data["T"]
      assert result.lat == result.raw_data["LAT"]
      assert result.lon == result.raw_data["LON"]
    end
  end
end
