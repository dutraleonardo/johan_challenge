defmodule JohanChallenge.Core.Repositories.DeviceTest do
  use JohanChallenge.DataCase

  alias JohanChallenge.Core.Repositories.Device, as: DeviceRepo

  import JohanChallenge.Factory

  setup do
    device = build(:device)
    device |> Repo.insert!()
    %{device: device}
  end

  describe "get_by_sid/1" do
    test "find a device by sim_sid", %{device: device} do
      {status, result} = DeviceRepo.get_by_sid(device.sim_sid)

      assert status == :ok
      assert result.id == device.id
      assert result.sim_sid == device.sim_sid
      assert result.inserted_at
      assert result.updated_at
    end

    test "failed to find a device that doesnt exists" do
      {status, result} =
        ("HS" <> Ecto.UUID.generate())
        |> DeviceRepo.get_by_sid()

      assert status == :error
      assert result == "Device not found"
    end
  end
end
