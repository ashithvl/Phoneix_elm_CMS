defmodule ElmPhxDbTodo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :password, :string
      add :is_admin, :boolean, default: 0

      timestamps()
    end
  end
end
