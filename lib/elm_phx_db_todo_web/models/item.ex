defmodule ElmPhxDbTodoWeb.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchase_item" do
    field :item, :string
    field :price, :integer
    field :count, :integer
    has_many :purchase_history, ElmPhxDbTodoWeb.Purchase

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:item, :price, :count])
    |> validate_required([:item, :price, :count])
  end

end
