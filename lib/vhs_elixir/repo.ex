defmodule VhsElixir.Repo do
  use Ecto.Repo,
    otp_app: :vhs_elixir,
    adapter: Ecto.Adapters.Postgres
end
