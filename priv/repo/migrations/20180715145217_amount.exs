defmodule ElmPhxDbTodo.Repo.Migrations.Amount do
  use Ecto.Migration

  def change do
    create table(:amount) do
      add :balance, :integer
      add :user_id, references(:user)

      timestamps()
    end
  end
end
