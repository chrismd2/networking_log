defmodule NetworkingLog.Repo do
  use Ecto.Repo,
    otp_app: :networking_log,
    adapter: Ecto.Adapters.Postgres
end
