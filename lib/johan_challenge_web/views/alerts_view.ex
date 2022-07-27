defmodule JohanChallengeWeb.AlertsView do
  use JohanChallengeWeb, :view

  def render("alert.json", %{alert: alert}) do
    %{
      id: alert.id,
      incident_dt: alert.incident_dt,
      value: alert.value,
      type: alert.type,
      lat: alert.lat,
      lon: alert.lon
    }
  end
  def render("show.json", %{alerts: alerts}) do
    %{
      data: Enum.map(alerts.entries, fn alert -> render("alert.json", %{alert: alert}) end),
      page: alerts.page_number,
      page_size: alerts.page_size,
      total_pages: alerts.total_pages,
      total_count: alerts.total_entries
    }
  end
end
