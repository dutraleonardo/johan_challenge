defmodule JohanChallenge.Core.Repositories.Alert do
  @moduledoc """
  Repository to handle alerts queries to database
  """
  alias Ecto.Multi
  alias JohanChallenge.Core.Schemas.{Alert, AlertAudit}
  alias JohanChallenge.Core.Utils
  alias JohanChallenge.Repo

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
end
