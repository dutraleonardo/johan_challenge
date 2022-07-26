defmodule JohanChallengeWeb.FallbackController do
  use JohanChallengeWeb, :controller

  def call(conn, {:error, msg}) when is_binary(msg) do
    conn
    |> put_status(:bad_request)
    |> put_view(JohanChallengeWeb.ErrorView)
    |> render("error.json", %{msg: msg})
  end
end
