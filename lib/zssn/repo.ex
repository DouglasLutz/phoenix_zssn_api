defmodule Zssn.Repo do
  use Ecto.Repo,
    otp_app: :zssn,
    adapter: Ecto.Adapters.Postgres
end
