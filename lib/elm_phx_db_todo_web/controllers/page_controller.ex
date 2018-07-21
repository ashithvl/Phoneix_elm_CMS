defmodule ElmPhxDbTodoWeb.PageController do
  use ElmPhxDbTodoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, _params) do
    render conn, "index.html"
  end

  def register(conn, _params) do
    render conn, "index.html"
  end
end
