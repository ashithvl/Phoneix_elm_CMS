defmodule ElmPhxDbTodoWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias ElmPhxDbTodoWeb.Router.Helpers

  def init(_params) do

  end

  def call(conn,_params) do
    # IO.inspect conn.assigns[:user]
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.auth_path(conn, :index))
      |> halt()
    end
  end

end
