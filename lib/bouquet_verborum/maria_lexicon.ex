defmodule BouquetVerborum.MariaLexicon do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "saba" do
    field :word, :string
    field :meaning, :string
    field :origin, :string
    field :book, :string
    field :chapter, :integer
    field :paragraph, :integer
    field :latitude, :string
    field :longitude, :string
    field :language, :string
  end

  def changeset(record, attrs) do
    record
    |> cast(attrs, [
      :word,
      :meaning,
      :origin,
      :book,
      :chapter,
      :paragraph,
      :latitude,
      :longitude,
      :language
    ])
  end
end
