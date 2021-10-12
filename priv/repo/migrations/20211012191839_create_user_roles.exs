defmodule NetworkingLog.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :role_id, :integer
      add :user_id, :integer
    end
  end
end
