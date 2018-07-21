defmodule ElmPhxDbTodoWeb.Purchase do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:is_purchased, :user, :item]}

  schema "purchase_history" do
    field :is_purchased, :boolean
    belongs_to :user, ElmPhxDbTodoWeb.User
    belongs_to :item, ElmPhxDbTodoWeb.Item

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :item_id])
    |> validate_required([:user_id, :item_id])
  end

end
