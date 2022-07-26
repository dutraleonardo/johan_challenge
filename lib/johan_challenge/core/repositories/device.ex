defmodule JohanChallenge.Core.Repositories.Device do
  @moduledoc """
  Device's repository to make queries on devices' db table
  """
  alias JohanChallenge.Core.Schemas.Device
  alias JohanChallenge.Repo

  @spec get_by_sid(any) :: {:error, <<_::128>>} | {:ok, any}
  def get_by_sid(sid) do
    case Repo.get_by(Device, sim_sid: sid) do
      nil ->
        {:error, "Device not found"}

      device ->
        {:ok, device}
    end
  end
end
