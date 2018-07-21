defmodule ElmPhxDbTodo.Repo.Migrations.AlterPurchaseHistory do
  use Ecto.Migration

  def change do
    alter table(:purchase_history) do
      add :item_id, references(:purchase_item)
    end
  end
end
