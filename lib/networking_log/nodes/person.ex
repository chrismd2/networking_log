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
      required: true
    )
  end

  def changeset(person, notes) when(is_list(notes)) do
    # default_val = %{notes: "none"}
    # Map.merge(attrs, default_val)
    IO.inspect(notes, label: "notes in changeset")
    person
    |> cast(%{}, [:name, :phone, :email])#, :notes, :interests, :places, :groups, :events])
    |> unique_constraint(:name, name: :name)
    |> validate_required([:name])
    |> put_assoc(:notes, notes)
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :phone, :email])#, :notes, :interests, :places, :groups, :events])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :name)
  end
end
