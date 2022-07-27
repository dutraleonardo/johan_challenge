defmodule JohanChallenge.Factory do
  alias JohanChallenge.Core.Schemas.{Alert, Caregiver, Device, HealthCenter, Patient}
  alias JohanChallenge.Repo

  def build(:health_center) do
    %HealthCenter{
      id: Ecto.UUID.generate(),
      name: "Johan Health Center"
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
      postal_code: "01234567-89",
      additional_info: "You can acceess the house through the back door"
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

  def build(:caregiver) do
    %Caregiver{
      id: Ecto.UUID.generate(),
      phone_number: "5585999887720"
    }
  end

  def build(:all) do
    health_center =
      build(:health_center)
      |> Repo.insert!()

    caregiver =
      build(:caregiver)
      |> Map.put(:health_center_id, health_center.id)
      |> Repo.insert!()

    patient =
      build(:patient)
      |> Map.put(:health_center_id, health_center.id)
      |> Repo.insert!()

    device =
      build(:device)
      |> Map.merge(%{health_center_id: health_center.id, patient_id: patient.id})
      |> Repo.insert!()

    alert =
      build(:alert)
      |> Map.put(:device_id, device.id)

    %{
      alert: alert,
      health_center: health_center,
      patient: patient,
      caregiver: caregiver,
      device: device
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
