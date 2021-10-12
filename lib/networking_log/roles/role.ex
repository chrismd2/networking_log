defmodule NetworkingLog.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    many_to_many :users, NetworkingLog.Accounts.User, join_through: "user_roles", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
  def changeset_assoc(struct, params) when(is_list(params)) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:users, params)
  end
end
