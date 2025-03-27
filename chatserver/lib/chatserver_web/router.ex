defmodule ChatserverWeb.Router do
  use ChatserverWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChatserverWeb do
    pipe_through :api
    options "/login", AuthController, :options
    post "/login", AuthController, :login
    options "/register", AuthController, :options
    post "/register", AuthController, :register
    post "/refresh", AuthController, :refresh
  end
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router
    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: UsersApiWeb.Telemetry
    end
  end

end
