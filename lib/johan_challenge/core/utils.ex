defmodule JohanChallenge.Core.Utils do
  @moduledoc """
  Function to be reused in multiple modules
  """
  def format_changeset_error(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", convert_to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc} #{k}: #{joined_errors}"
    end)
  end

  def format_changeset_error(changeset), do: changeset

  defp convert_to_string(val) when is_list(val) do
    Enum.join(val, ",")
  end

  defp convert_to_string(val), do: to_string(val)
end
