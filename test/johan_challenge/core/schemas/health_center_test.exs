defmodule JohanChallenge.Core.Schemas.HealthCenterTest do
  use JohanChallenge.DataCase

  alias JohanChallenge.Core.Schemas.HealthCenter

  describe "health_centers" do
    @valid_attrs %{name: "Holland Health Center"}
    @invalid_attrs %{full_name: "Invalid Health Center", bio: "this is a health center"}

    test "changeset/1 with valid data" do
      changeset = HealthCenter.changeset(@valid_attrs)
      assert changeset.valid? == true
      assert changeset.errors == []
      assert changeset.changes.name == @valid_attrs.name
    end

    test "changeset/1 with invalid data" do
      changeset = HealthCenter.changeset(@invalid_attrs)
      assert changeset.valid? == false
      assert changeset.errors != []
      {error_field, {_, error}} = changeset.errors |> hd()
      assert error_field == :name
      assert error == [validation: :required]
    end
  end
end
