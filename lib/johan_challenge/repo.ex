defmodule JohanChallenge.Repo do
  use Ecto.Repo,
    otp_app: :johan_challenge,
    adapter: Ecto.Adapters.Postgres
end
