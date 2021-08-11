defmodule NetworkingLog.Nodes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "notes" do
    field :text,              :string

    many_to_many :people,     Nodes.Person, join_through: "person_to_notes"
    # many_to_many :notes,      Nodes.Note, join_through: "notes"
    # many_to_many :interests,  Nodes.Interest, join_through: "interests"
    # many_to_many :places,     Nodes.Place, join_through: "places"
    # many_to_many :groups,     Nodes.Group, join_through: "groups"
    # many_to_many :events,     Nodes.Event, join_through: "events"

    timestamps()
  end

  def changeset(struct, params = %{}) do
    struct
    |> cast(params, [:text])
    |> cast_assoc(
      :people,
      required: true
    )
  end

  def changeset(note, people) when(is_list(people)) do
    IO.write("\n\nFLAG\n\n")
    IO.inspect(people, label: "people in changeset")
    IO.inspect(note, label: "note in changeset")
    # default_val = %{people: "none"}
    # Map.merge(attrs, default_val)
    note
    |> cast(%{}, [:text])#, :people, :notes, :interests, :places, :groups, :events])
    # |> unique_constraint(:text, name: :text)
    # |> validate_required([:text])
    |> put_assoc(:people, people, join_through: "person_to_notes", on_replace: :delete)
  end

  def changeset(note, attrs) do
    note
    |> cast(attrs, [:text])#, :people, :notes, :interests, :places, :groups, :events])
    |> unique_constraint(:text, name: :text)
    |> validate_required([:text])
  end
end
