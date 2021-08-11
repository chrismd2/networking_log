defmodule NetworkingLog.Nodes.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "people" do
    field :name,              :string
    field :phone,             :string, size: 10
    field :email,             :string

    many_to_many :notes,      Nodes.Note, join_through: "person_to_notes"

    timestamps()
  end

  def changeset(struct, params = %{}) do
    struct
    |> cast(params, [:name, :phone, :email])
    |> cast_assoc(
      :notes,
      required: false
    )
  end
end
