defmodule ElmPhxDbTodoWeb.AdminController do
  use ElmPhxDbTodoWeb, :controller

  alias ElmPhxDbTodo.Repo
  alias ElmPhxDbTodoWeb.User
  alias ElmPhxDbTodoWeb.Item
  alias ElmPhxDbTodoWeb.Amount

  import Ecto.Query

  plug ElmPhxDbTodoWeb.Plugs.RequireAuth
  plug :check_admin

  defp check_admin(conn, _params) do
    if Repo.get(User, get_session(conn, :user_id)).is_admin == true do
      conn
    else
      conn
      |> put_flash(:error, "Contact Your Adminstrator")
      |> redirect(to: auth_path(conn, :index))
      |> halt()
    end
  end

  def index(conn,_params) do
    render conn, "index.html"
  end

  def showUser(conn,_params) do
    users = Amount
            |> join(:inner, [a], a in assoc(a, :user))
            |> where([a, u], u.is_admin == false)
            |> select([a, u],  {u.name, a.balance, u.id})
            |> Repo.all
    output_post users
    render conn, "showUser.html", users: users
  end

  def output_post([user|users]) do
    IO.inspect user
    output_post(users)
  end

  def output_post([]), do: nil

  def showInventory(conn,_params) do
    render conn, "showInventory.html", items: Repo.all(Item)
  end

	def newItem(conn, _params) do
		changeset = Item.changeset(%Item{}, %{})
		render conn, "newItem.html", changeset: changeset
	end

	def addItem(conn, %{"item" => item}) do
    changeset = Item.changeset(%Item{}, item)
		case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Item Added")
        |> redirect(to: admin_path(conn, :showInventory))
      {:error, changeset} ->
  		    render conn, "newItem.html", changeset: changeset
    end
	end

  def editItem(conn, %{"id" => item_id}) do
    item = Repo.get(Item, item_id)
    changeset = Item.changeset(item)

    render conn, "editItem.html", changeset: changeset, item: item
  end

  def updateItem(conn, %{"id" => item_id, "item" => item}) do
     old_item = Repo.get(Item, item_id)
     changeset = Item.changeset(old_item, item)

     case Repo.update(changeset) do
       {:ok, _item} ->
         conn
         |> put_flash(:info, "Item Updated")
         |> redirect(to: admin_path(conn, :showInventory))
       {:error, changeset} ->
         render conn, "editItem.html", changeset: changeset, item: old_item
    end
  end

  def deleteItem(conn, %{"id" => item_id}) do
    Repo.get!(Item, item_id) |> Repo.delete!
    conn
      |> put_flash(:error, "Item Deleted")
      |> redirect(to: admin_path(conn, :showInventory))
  end

  def showUserHistory(conn, %{"id" => user_id}) do
    items = Item
            |> join(:inner, [i], p in assoc(i, :purchase_history))
            |> where([i, p], p.user_id == ^user_id and p.is_purchased == true)
            |> group_by([i, p], p.item_id)
            |> select([i, p],  {i.item, p.updated_at, count(p.item_id), i.price})
            |> Repo.all
    if length(items) == 0 do
      conn
        |> put_flash(:error, "No History to Show!")
        |> redirect(to: admin_path(conn, :showUser))
    else
     render conn, "showHistory.html", items: items
    end
  end
end
