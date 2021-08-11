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

  def changeset_assoc(struct, params) when(is_list(params)) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:people, params)
  end
  def changeset(struct, params = %{}) do
    struct
    |> cast(params, [:text])
    |> cast_assoc(
      :people,
      required: false
    )
  end
end
