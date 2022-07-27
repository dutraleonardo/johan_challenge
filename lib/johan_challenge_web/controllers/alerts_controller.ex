defmodule JohanChallengeWeb.AlertsController do
  use JohanChallengeWeb, :controller

  alias JohanChallenge.Core.Repositories.Alert, as: AlertRepo
  alias JohanChallenge.Core.Repositories.Caregiver, as: CaregiverRepo
  alias JohanChallenge.Core.Repositories.Device, as: DeviceRepo
  alias JohanChallenge.Core.Services.Alert, as: AlertService
  alias JohanChallenge.Notifier.SMS

  action_fallback JohanChallengeWeb.FallbackController

  @spec create(any, nil | maybe_improper_list | map) :: {:error, any} | {:ok, any} | Plug.Conn.t()
  def create(conn, params) do
    with {:ok, %{id: device_id}} <- DeviceRepo.get_by_sid(params["sim_sid"]),
         {:ok, parsed_data} <- {:ok, AlertService.parse_data(params)},
         {:ok, result} <- parsed_data |> Map.put(:device_id, device_id) |> AlertRepo.insert_alert_with_audit(),
         {:ok, alert_notification} <- AlertRepo.get_alert_notification(result.id),
         {:ok, %{phone_number: caregiver_phone}} <-
           CaregiverRepo.get_caregiver_to_patient(alert_notification.patient_id),
         {:ok, _notificaton} <- SMS.call(alert_notification, caregiver_phone) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("alert.json", %{alert: result})
    end
  end

  @spec show(any, map) :: {:error, <<_::128>>} | Plug.Conn.t()
  def show(conn, %{"page_size" => page_size, "page" => page_number} = params) do
    with {:ok, alerts} <-
           params
           |> Map.drop(["page", "page_size"])
           |> AlertRepo.filter(%{page_size: page_size, page: page_number}) do
      conn
      |> put_status(:ok)
      |> render("show.json", alerts: alerts)
    end
  end
end
