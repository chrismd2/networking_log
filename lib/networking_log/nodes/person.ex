defmodule NetworkingLog.Nodes.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "people" do
    field :name,              :string
    field :phone,             :string, size: 10
    field :email,             :string

    many_to_many :notes,      Nodes.Note, join_through: "notes"

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :phone, :email])#, :notes, :interests, :places, :groups, :events])
    |> put_assoc(:notes, attrs)
    |> validate_required([:name])
  end
end
