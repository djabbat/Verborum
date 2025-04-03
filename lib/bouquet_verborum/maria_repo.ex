defmodule BouquetVerborum.MariaRepo do
  use Ecto.Repo,
    otp_app: :bouquet_verborum,
    adapter: Ecto.Adapters.MyXQL
end
