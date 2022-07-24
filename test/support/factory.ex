defmodule JohanChallenge.Factory do
  alias JohanChallenge.Core.Schemas.{HealthCenter, Patient}
  alias JohanChallenge.Repo

  def build(:health_center) do
    %HealthCenter{name: "Amazing Health Center"}
  end

  def build(:patient) do
    %Patient{
      first_name: "John",
      last_name: "Doe",
      address: "Delftechpark 23",
      city: "Delft",
      country: "Netherlands",
      state: "Zuid-Holland",
      postal_code: "01234567-89"
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
