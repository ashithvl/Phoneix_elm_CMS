defmodule ElmPhxDbTodo.Repo.Migrations.AlterTablePurchaseHistory do
  use Ecto.Migration

  def change do
    alter table(:purchase_history) do
      add :is_purchased, :boolean, default: 0
    end
  end
end
