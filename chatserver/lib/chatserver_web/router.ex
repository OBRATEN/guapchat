defmodule ChatserverWeb.Router do
  use ChatserverWeb, :router
  pipeline :api do
    plug :accepts, ["json"]
  end
  scope "/api", ChatserverWeb do
    pipe_through :api
    get "/users", UserController, :index
    put "/users", UserController, :edit
    post "/users", UserController, :create
    delete "/users", UserController, :delete
    get "/messages", MessageController, :index
    post "/messages", MessageController, :create
  end
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router
    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: UsersApiWeb.Telemetry
    end
  end
end
