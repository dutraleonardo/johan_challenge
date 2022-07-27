defmodule JohanChallengeWeb.AlertsControllerTest do
  use JohanChallengeWeb.ConnCase, async: false

  alias JohanChallenge.Core.Repositories.Alert, as: AlertRepo
  alias JohanChallenge.Repo

  import JohanChallenge.Factory

  @valid_alert %{
    incident_dt: "2015-07-30T20:00:00Z",
    value: "200",
    type: "FALL",
    lat: "52.1544408",
    lon: "4.2934847"
  }

  setup %{conn: conn} do
    device = build(:device)
    device |> Repo.insert!()

    payload = %{
      status: "received",
      api_version: "v1",
      sim_sid: device.sim_sid,
      content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847",
      direction: "from_sim"
    }

    invalid_payload = %{
      sim_sid: Ecto.UUID.generate(),
      content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408"
    }

    %{
      device: device,
      conn: put_req_header(conn, "accept", "application/json"),
      payload: payload,
      invalid_payload: invalid_payload
    }
  end

  describe "POST /api/alerts" do
    test "send request with valid payload", %{payload: payload, conn: conn} do
      response = post(conn, "/api/alerts", payload)

      assert response.status == 200
      assert String.contains?(response.resp_body, "incident_dt")
      assert String.contains?(response.resp_body, "type")
      assert String.contains?(response.resp_body, "value")
    end

    test "send request with invalid payload: device error", %{invalid_payload: invalid_payload, conn: conn} do
      response = post(conn, "/api/alerts", invalid_payload)
      body = Jason.decode!(response.resp_body)
      assert response.status == 400
      assert body["error"] == "Device not found"
    end

    test "send request with invalid payload: longitude error", %{
      device: device,
      invalid_payload: invalid_payload,
      conn: conn
    } do
      invalid_payload =
        invalid_payload
        |> Map.put(:sim_sid, device.sim_sid)

      response = post(conn, "/api/alerts", invalid_payload)
      body = Jason.decode!(response.resp_body)
      assert response.status == 400
      assert String.contains?(body["error"], "lon: can't be blank")
    end
  end

  describe "GET /api/alerts" do
    setup %{device: device} do
      alerts =
        Enum.map(
          1..10,
          fn _x ->
            @valid_alert
            |> Map.put(:device_id, device.id)
            |> AlertRepo.insert_alert()
            |> elem(1)
          end
        )

      {:ok, alerts: alerts}
    end

    test "filter by at_dt e type_key", %{conn: conn} do
      params = %{
        "at_dt" => "2015-07-30T20:00:00Z",
        "type_key" => "FALL",
        "page" => "1",
        "page_size" => "5"
      }

      response = get(conn, "/api/alerts", params)
      body = Jason.decode!(response.resp_body)
      assert body["page"] == 1
      assert body["page_size"] == 5
      assert body["total_count"] == 10
      assert body["total_pages"] == 2
      assert length(body["data"]) == String.to_integer(params["page_size"])
    end
  end
end
