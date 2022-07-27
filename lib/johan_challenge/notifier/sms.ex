defmodule JohanChallenge.Notifier.SMS do
  require Logger

  defmodule Message do
    defstruct [:incident_datetime, :alert_type, :patient_first_name, :patient_last_name, :additional_information]
  end
  def call(%{incident_dt: incident_dt, type: type, first_name: first_name, last_name: last_name, additional_info: additional_info}, phone_number) do
    message = %Message{
      incident_datetime: incident_dt,
      alert_type: type,
      patient_first_name: first_name,
      patient_last_name: last_name,
      additional_information: additional_info
    }
    response = send_sms(message, phone_number)
    Logger.info(elem(response, 1))
    response
  end
  def call(_message, _phone_number) do
    {:error, "Missing fields"}
  end
  defp send_sms(%Message{} = message, phone_number) do
    Logger.info("Sending the following message #{inspect(message)} to phone number #{phone_number}")
    {:ok, "SMS sent successfully"}
  end
end
