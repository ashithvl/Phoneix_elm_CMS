defmodule ElmPhxDbTodo.Repo.Migrations.PurchaseItem do
  use Ecto.Migration

  def change do
    create table(:purchase_item) do
      add :item, :string
      add :price, :integer
      add :count, :integer

      timestamps()
    end
  end
end
