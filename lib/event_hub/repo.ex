defmodule EventHub.Repo do
  use Ecto.Repo,
    otp_app: :event_hub,
    adapter: Ecto.Adapters.Postgres
end
