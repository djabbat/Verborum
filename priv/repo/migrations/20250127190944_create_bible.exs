defmodule BouquetVerborum.Repo.Migrations.CreateBible do
  use Ecto.Migration

  def change do
    create table(:bible, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :book, :string, default: ""
      add :chapter, :integer
      add :paragraph, :integer
      add :text, :text, default: ""

      timestamps()
    end
  end
end
