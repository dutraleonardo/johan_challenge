defmodule JohanChallenge.Core.Repositories.Alert do
  @moduledoc """
  Repository to handle alerts queries to database
  """
  alias Ecto.Multi
  alias JohanChallenge.Core.Schemas.{Alert, AlertAudit}
  alias JohanChallenge.Core.Utils
  alias JohanChallenge.Repo

  import Ecto.Query

  require Logger

  @spec insert_alert(%{optional(:__struct__) => none, optional(atom | binary) => any}) :: {:error, any} | {:ok, any}
  def insert_alert(data) do
    case Alert.changeset(data) do
      %Ecto.Changeset{valid?: true} = changeset ->
        result =
          changeset
          |> Repo.insert!()

        {:ok, result}

      %Ecto.Changeset{valid?: false} = changeset ->
        result =
          changeset
          |> Utils.format_changeset_error()

        {:error, result}
    end
  end

  @spec insert_alert_audit(%{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, any} | {:ok, any}
  def insert_alert_audit(data) do
    case AlertAudit.changeset(data) do
      %Ecto.Changeset{valid?: true} = changeset ->
        result =
          changeset
          |> Repo.insert!()

        {:ok, result}

      %Ecto.Changeset{valid?: false} = changeset ->
        result =
          changeset
          |> Utils.format_changeset_error()

        {:error, result}
    end
  end

  @spec insert_alert_with_audit(any) :: any
  def insert_alert_with_audit(data) do
    Multi.new()
    |> Multi.run(:alert, fn _repo, _changes ->
      insert_alert(data)
    end)
    |> Multi.run(:alert_audit, fn _repo, %{alert: alert} ->
      data
      |> Map.put(:alert_id, alert.id)
      |> insert_alert_audit()
    end)
    |> Multi.run(:full_alert, fn _repo, %{alert: alert} ->
      get_full_alert_by_id(alert.id)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{full_alert: alert}} ->
        {:ok, alert}

      {:error, _, message, _} ->
        {:error, message}
    end
  end

  @spec get_by_id(any) :: any
  def get_by_id(id) do
    Alert
    |> Repo.get(id)
  end

  @spec get_full_alert_by_id(any) ::
          {:error, <<_::120>>} | {:ok, nil | [%{optional(atom) => any}] | %{optional(atom) => any}}
  def get_full_alert_by_id(id) do
    case get_by_id(id) do
      nil ->
        {:error, "Alert not found"}

      alert ->
        result =
          alert
          |> Repo.preload([:alert_audit, :device])

        {:ok, result}
    end
  end

  def filter(filters, page_opts) do
    case filtering(filters, page_opts) do
      %{entries: []} ->
        {:error, "Alerts not found"}

      alerts ->
        {:ok, alerts}
    end
  end

  defp filtering(filters, page_opts) do
    Alert
    |> build_query(filters)
    |> Repo.paginate(page_opts)
  end

  defp incident_filter(query, incident_dt) do
    query
    |> where([a], a.incident_dt == ^incident_dt)
  end

  defp type_filter(query, type) do
    query
    |> where([a], a.type == ^type)
  end

  defp build_query(queryable, filters),
    do: Enum.reduce(filters, queryable, &apply_filter/2)

  defp apply_filter(clause, query) do
    case clause do
      {"at_dt", incident_dt} ->
        incident_filter(query, incident_dt)

      {"type_key", type} ->
        type_filter(query, type)
    end
  end
end
