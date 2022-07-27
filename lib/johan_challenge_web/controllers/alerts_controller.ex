defmodule JohanChallengeWeb.AlertsController do
  use JohanChallengeWeb, :controller

  alias JohanChallenge.Core.Repositories.Alert, as: AlertRepo
  alias JohanChallenge.Core.Repositories.Device, as: DeviceRepo
  alias JohanChallenge.Core.Services.Alert, as: AlertService

  action_fallback JohanChallengeWeb.FallbackController

  @spec create(any, nil | maybe_improper_list | map) :: {:error, any} | {:ok, any} | Plug.Conn.t()
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
