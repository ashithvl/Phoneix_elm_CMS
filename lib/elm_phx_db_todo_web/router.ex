defmodule ElmPhxDbTodoWeb.Router do
  use ElmPhxDbTodoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ElmPhxDbTodoWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElmPhxDbTodoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", AuthController, :index
    post "/", AuthController, :index
    post "/login", AuthController, :login
    get "/register", AuthController, :register
    post "/register", AuthController, :registeration
    post "/signout", AuthController, :signout

    get "/admin", AdminController, :index
    get "/admin/showInventory", AdminController, :showInventory
    get "/admin/showUser", AdminController, :showUser
    get "/admin/showUserHistory/:id", AdminController, :showUserHistory

    get "/admin/newItem", AdminController, :newItem
    post "/admin/addItem", AdminController, :addItem
    get "/admin/:id/editItem", AdminController, :editItem
    put "/admin/:id", AdminController, :updateItem
    delete "/admin/:id", AdminController, :deleteItem

    get "/user", UserController, :index
    get "/user/addItem/:item_id/:user_id", UserController, :addItem
    get "/user/cart/:id", UserController, :cart
    get "/user/checkout/:id", UserController, :checkout
    get "/user/deleteCart/:id", UserController, :deleteCart
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElmPhxDbTodoWeb do
  #   pipe_through :api
  # end
end
