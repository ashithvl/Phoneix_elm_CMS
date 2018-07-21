defmodule ElmPhxDbTodoWeb.AuthController do
  use ElmPhxDbTodoWeb, :controller

  alias ElmPhxDbTodo.Repo
  alias ElmPhxDbTodoWeb.User

  import Ecto.Query

  def index(conn, _params) do
		changeset = User.changeset(%User{}, %{})
    render conn, "index.html", changeset: changeset
  end

  def login(conn, %{"user" => user}) do
		changeset = User.changeset(%User{},user)
    %{"name" => name, "password" => password} = user
    oldUser = User
                |> where([u], u.name == ^name and u.password == ^password)
                |> select([u], {u.id})
                |> Repo.all

    IO.inspect List.first(oldUser)

    if length(oldUser) == 1 do
      is_admin = User
                  |> where([u], u.name == ^name and u.password == ^password and u.is_admin == true)
                  |> select([u], {u.id})
                  |> Repo.all
      if length(is_admin) == 1 do
        conn
          |> put_flash(:info, "Login Successfull!")
          |> put_session(:user_id, elem(List.first(oldUser), 0))
          |> redirect(to: admin_path(conn, :index))
        else
          conn
            |> put_flash(:info, "Login Successfull!")
            |> put_session(:user_id, elem(List.first(oldUser), 0))
            |> redirect(to: user_path(conn, :index))
      end
    else
      conn
        |> put_flash(:info, "Invalid Credentials!")
        |> redirect(to: auth_path(conn, :index))
    end
  end

  def register(conn, _params) do
		changeset = User.changeset(%User{}, %{})
    render conn, "register.html", changeset: changeset
  end

  def registeration(conn, %{"user" => user}) do
		changeset = User.changeset(%User{},user)
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Registration Successful")
        |> redirect(to: auth_path(conn, :index))
      {:error, changeset} ->
        render conn, "register.html", changeset: changeset
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: auth_path(conn, :index))
  end

end
