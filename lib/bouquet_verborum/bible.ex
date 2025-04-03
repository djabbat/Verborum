defmodule BouquetVerborum.Bible do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bible" do
    field :book, :string
    field :chapter, :integer
    field :paragraph, :integer
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(record, attrs) do
    record
    |> cast(attrs, [
      :book,
      :chapter,
      :paragraph,
      :text
    ])
  end
end
