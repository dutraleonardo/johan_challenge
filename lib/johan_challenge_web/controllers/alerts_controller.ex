defmodule JohanChallengeWeb.AlertsController do
  use JohanChallengeWeb, :controller

  alias JohanChallenge.Core.Repositories.Alert, as: AlertRepo
  alias JohanChallenge.Core.Repositories.Device, as: DeviceRepo
  alias JohanChallenge.Core.Services.Alert, as: AlertService

  action_fallback JohanChallengeWeb.FallbackController

  def create(conn, params) do
    with {:ok, %{id: device_id}} <- DeviceRepo.get_by_sid(params["sim_sid"]),
         {:ok, parsed_data} <- {:ok, AlertService.parse_data(params)},
         {:ok, result} <- parsed_data |> Map.put(:device_id, device_id) |> AlertRepo.insert_alert_with_audit() do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("alert.json", %{alert: result})
    end
  end
end
