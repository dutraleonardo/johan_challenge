defmodule JohanChallengeWeb.AlertsView do
  use JohanChallengeWeb, :view

  def render("alert.json", %{alert: alert}) do
    %{
      incident_dt: alert.incident_dt,
      value: alert.value,
      type: alert.type,
      lat: alert.lat,
      lon: alert.lon
    }
  end
end
