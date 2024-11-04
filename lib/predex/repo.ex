defmodule Predex.Repo do
  use Ecto.Repo,
    otp_app: :predex,
    adapter: Ecto.Adapters.SQLite3
end
