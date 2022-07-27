defmodule JohanChallenge.Repo do
  use Ecto.Repo,
    otp_app: :johan_challenge,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 2
end
