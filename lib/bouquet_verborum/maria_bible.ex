defmodule BouquetVerborum.MariaBible do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "biblia" do
    field :book, :string
    field :chapter, :integer
    field :paragraph, :integer
    field :text, :string
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
