defmodule JohanChallenge.Factory do
  alias JohanChallenge.Core.Schemas.{Alert, Device, HealthCenter, Patient}
  alias JohanChallenge.Repo

  def build(:health_center) do
    %HealthCenter{
      id: Ecto.UUID.generate(),
      name: "Amazing Health Center"
    }
  end

  def build(:patient) do
    %Patient{
      id: Ecto.UUID.generate(),
      first_name: "John",
      last_name: "Doe",
      address: "Delftechpark 23",
      city: "Delft",
      country: "Netherlands",
      state: "Zuid-Holland",
      postal_code: "01234567-89"
    }
  end

  def build(:device) do
    %Device{
      id: Ecto.UUID.generate(),
      sim_sid: "HS098931231234563ABF"
    }
  end

  def build(:alert) do
    %Alert{
      id: Ecto.UUID.generate(),
      incident_dt: NaiveDateTime.utc_now(),
      value: "200",
      type: :FALL,
      lat: "52.1544408",
      lon: "4.2934847"
    }
  end

  def build(factory_name, attrs) do
    factory_name
    |> build()
    |> struct!(attrs)
  end

  def insert!(factory_name, attrs \\ []) do
    factory_name
    |> build(attrs)
    |> Repo.insert!()
  end
end
