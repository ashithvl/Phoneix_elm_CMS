defmodule ElmPhxDbTodoWeb.UserController do
  use ElmPhxDbTodoWeb, :controller

  alias ElmPhxDbTodo.Repo
  alias ElmPhxDbTodoWeb.User
  alias ElmPhxDbTodoWeb.Item
  alias ElmPhxDbTodoWeb.Amount
  alias ElmPhxDbTodoWeb.Purchase

  import Ecto.Query

  plug ElmPhxDbTodoWeb.Plugs.RequireAuth when action in [:index, :addItem, :cart, :checkout, :deleteCart]

  plug ElmPhxDbTodoWeb.Plugs.RequireAuth
  plug :check_admin

  defp check_admin(conn, _params) do
    if Repo.get(User, get_session(conn, :user_id)).is_admin == false do
      conn
    else
      conn
      |> put_flash(:error, "Adminstrator can't Login as User")
      |> redirect(to: auth_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    balance = Amount
                |> where([u], u.user_id == ^get_session(conn, :user_id))
                |> select([u], {u.user_id, u.balance})
                |> Repo.all
    render conn, "index.html", items: Repo.all(Item), balance: balance |> List.first |> elem(1)
  end

  def addItem(conn, %{"item_id" => item_id, "user_id" => user_id}) do
    user = Repo.get(User, user_id)
    item = Repo.get(Item, item_id)

    changeset = Purchase.changeset(%Purchase{}, %{user_id: user_id,
                  item_id: item_id})

    cond do
      item.count > 0 ->
        case Repo.insert(changeset) do
          {:ok, sucess} ->
            c = item.count - 1
            from(i in Item, where: i.id == ^item_id, update: [set: [count: ^c]])
                      |> Repo.update_all([])
            conn
            |> put_flash(:info, item.item <> " - Added to cart")
            |> redirect(to: user_path(conn, :index))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "Something went Wrong")
            |> redirect(to: user_path(conn, :index))
        end
      true ->
        conn
        |> put_flash(:error, "Item Unavaliable")
        |> redirect(to: user_path(conn, :index))
    end

  end

  def cart(conn, %{"id" => id }) do

    items = Purchase
            |> join(:inner, [p], a in assoc(p, :item))
            |> where([p, i], p.user_id == ^id and p.is_purchased == false)
            |> group_by([p, i], p.item_id)
            |> select([p, i],  {i.item, i.price, count(p.item_id), sum(i.price)})
            |> Repo.all

    total = Purchase
            |> join(:inner, [p], a in assoc(p, :item))
            |> where([p, i], p.user_id == ^id and p.is_purchased == false)
            |> select([p, i],  {sum(i.price)})
            |> Repo.all

    if length(items) == 0 do
      conn
        |> put_flash(:error, "Cart is Empty!")
        |> redirect(to: user_path(conn, :index))
    else
        render conn, "cart.html", items: items, total: List.first(total)
    end
  end

  def checkout(conn, %{"id" => id }) do
    total = Purchase
              |> join(:inner, [p], a in assoc(p, :item))
              |> where([p, i], p.user_id == ^id and p.is_purchased == false)
              |> select([p, i],  {sum(i.price)})
              |> Repo.all
    balance = Amount
                |> where([u], u.user_id == ^id)
                |> select([u], {u.user_id, u.balance})
                |> Repo.all

    cond do
      Decimal.cmp(elem(List.first(total), 0), Decimal.new(elem(List.first(balance), 1))) == :gt ->
        IO.inspect "greater than"
        conn
          |> put_flash(:error,
            "Insufficiant Balance and your current balance is Rs." <>
             Kernel.inspect(List.first(balance))
              |> String.replace("{", "")
              |> String.replace( "}", ""))
          |> redirect(to: user_path(conn, :index))
      Decimal.cmp(elem(List.first(total), 0), Decimal.new(elem(List.first(balance), 1))) == :lt ->
        IO.inspect "less than"
        a = elem(List.first(balance), 1)
        b = Kernel.inspect(List.first(total))
          |> String.slice(10..12)
          |> String.replace( "}", "")
          |> String.replace( ">", "")
          |> Integer.parse
          |> elem(0)
        c = a - b

        from(a in Amount, where: a.user_id == ^id, update: [set: [balance: ^c]])
          |> Repo.update_all([])

        from(p in Purchase, where: p.user_id == ^id, update: [set: [is_purchased: true]])
          |> Repo.update_all([])
          conn
            |> put_flash(:info, "Checkout Successfully!")
            |> redirect(to: user_path(conn, :index))

      true ->
        conn
    end
  end

  def deleteCart(conn, %{"id" => id }) do
    items = Purchase
            |> where([p], p.user_id == ^id and p.is_purchased == false)
            |> group_by([p], p.item_id)
            |> select([p], {count(p.item_id), p.item_id})
            |> Repo.all

    Enum.each items, fn item ->
      count = Repo.get(Item,elem(item, 1))
      c = count.count + elem(item, 0)
      from(a in Item, where: a.id == ^elem(item, 1), update: [set: [count: ^c]])
          |> Repo.update_all([])
    end

    from(p in Purchase, where: p.user_id == ^id and p.is_purchased == false)
      |> Repo.delete_all
      conn
        |> put_flash(:error, "Cart Removed!")
        |> redirect(to: user_path(conn, :index))
  end

  def output_post([user|users]) do
    IO.inspect user
    output_post(users)
  end

  def output_post([]), do: nil

end
