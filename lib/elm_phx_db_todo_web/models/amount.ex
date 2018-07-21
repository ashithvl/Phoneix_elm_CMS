defmodule ElmPhxDbTodoWeb.Amount do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:balance, :user]}

  schema "amount" do
    field :balance, :integer
    belongs_to :user, ElmPhxDbTodoWeb.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:balance])
    |> validate_required([:balance])
  end

end
