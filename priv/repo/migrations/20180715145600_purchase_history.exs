defmodule ElmPhxDbTodo.Repo.Migrations.PurchaseHistory do
  use Ecto.Migration

  def change do
    create table(:purchase_history) do
      add :user_id, references(:user)

      timestamps()
    end
  end
end
