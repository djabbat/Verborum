defmodule BouquetVerborum.Lexicon do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lexicon" do
    field :word, :string
    field :meaning, :string
    field :origin, :string
    field :book, :string
    field :chapter, :integer
    field :paragraph, :integer
    field :latitude, :string
    field :longitude, :string
    field :language, :string

    timestamps(type: :utc_datetime)
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

  def search_changeset(input, attrs) do
    input
    |> cast(attrs, [:input])
  end
end
