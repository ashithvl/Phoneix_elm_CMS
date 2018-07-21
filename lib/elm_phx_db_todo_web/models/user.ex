defmodule ElmPhxDbTodoWeb.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:name]}

  schema "user" do
    field :name, :string
    field :password, :string
    field :is_admin, :boolean
    has_many :amounts, ElmPhxDbTodoWeb.Amount
    has_many :purchase_history, ElmPhxDbTodoWeb.Purchase

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
  end

end
