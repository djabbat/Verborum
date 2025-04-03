defmodule BouquetVerborum.Repo.Migrations.CreateLexicon do
  use Ecto.Migration

  def change do
    create table(:lexicon, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :word, :string, default: ""
      add :meaning, :text, default: ""
      add :origin, :string, default: ""
      add :book, :string, default: ""
      add :chapter, :integer
      add :paragraph, :integer
      add :latitude, :string, default: ""
      add :longitude, :string, default: ""
      add :language, :string, default: ""

      timestamps()
    end
  end
end
