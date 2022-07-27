defmodule JohanChallenge.Core.Services.Alert do
  @moduledoc """
  Alert's service to handle data and aggregate multiple operations with repositories
  """

  def parse_data(params) do
    raw_data = parse_raw_data(params)

    parse_content(raw_data)
    |> Map.put(:raw_data, raw_data)
  end

  defp parse_raw_data(%{"content" => content}) do
    content
    |> String.split(" ")
    |> List.delete_at(0)
    |> Enum.map(fn item -> String.split(item, "=") end)
    |> Enum.flat_map(fn item -> item end)
    |> Enum.chunk_every(2)
    |> Map.new(fn [key, value] -> {key, value} end)
  end

  defp parse_content(raw_data) do
    %{
      incident_dt: raw_data["DT"],
      value: raw_data["VAL"],
      type: raw_data["T"],
      lat: raw_data["LAT"],
      lon: raw_data["LON"]
    }
  end
end
