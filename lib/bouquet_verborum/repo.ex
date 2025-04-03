defmodule BouquetVerborum.Repo do
  use Ecto.Repo,
    otp_app: :bouquet_verborum,
    adapter: Ecto.Adapters.Postgres
end
