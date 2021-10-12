defmodule NetworkingLog.Roles do
  @moduledoc """
  The Roles context.
  """

  import Ecto.Query, warn: false
  alias NetworkingLog.Repo

  alias NetworkingLog.Roles.Role

  def get_user_list_for_role(%NetworkingLog.Roles.Role{} = role)  do
    role = Repo.preload(role, :users)
    IO.inspect(role, label: "role in get_user_list_for_role")
    role.users
  end
  defp revoke_helper([a_user | tail] = users_list, revoked_user) when(is_list(users_list)) do
    if(a_user != revoked_user && tail != []) do
      [a_user, revoke_helper(tail, revoked_user)]
    else
      tail
    end
  end
  def revoke_role(user: %NetworkingLog.Accounts.User{} = user, role: role) do
    IO.inspect(user, label: "user")
    IO.inspect(role, label: "role")

    role_record = NetworkingLog.Roles.get_role!(role)
    |> NetworkingLog.Repo.preload(:users)
    remaining_user_list = revoke_helper(role_record.users, user)

    role_record
    |> NetworkingLog.Roles.Role.changeset_assoc(remaining_user_list)
    |> NetworkingLog.Repo.update
  end
  def assign_role(user: %NetworkingLog.Accounts.User{} = user, role: role) when is_binary(role) do
    role_record = NetworkingLog.Roles.get_role!(role)
    existitng_user_list = get_user_list_for_role(role_record)

    role_record
    |> NetworkingLog.Repo.preload(:users)
    |> NetworkingLog.Roles.Role.changeset_assoc([user]++existitng_user_list)
    |> NetworkingLog.Repo.update
  end

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end
  def list_roles_by_name do
    Repo.all(Role)
    |> Enum.map(fn(a_role) -> a_role.name end)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id) when(is_integer(id)), do: Repo.get!(Role, id)


  def get_role!(name) when(is_binary(name)) do
    Repo.get_by!(Role, name: name)
  end

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end
end
