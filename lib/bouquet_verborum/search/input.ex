defmodule BouquetVerborum.Search.Input do
  use Ecto.Schema
  import Ecto.Changeset

  # defstruct input: nil
  schema "inputs" do
    field :word, :string
  end

  # def changeset(input, attrs) do
  #   input
  #   |> cast(attrs, [
  #     :input
  #   ])
  # end

  def changeset(input, params \\ %{}) do
    input
    |> cast(params, [:word])
  end
end
