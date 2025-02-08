defmodule BlogAppWeb.Router do
  use BlogAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BlogAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogAppWeb do
    pipe_through :browser

    live "/login", UserSessionLive, :new
    live "/register", UserRegistrationLive, :new
    live "/", LandingLive, :index
    live "/home", HomeLive, :index
    live "/dashboard", DashboardLive, :index
    live "/posts", PostLive.Index, :index
    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/edit", PostLive.Edit, :edit
    live "/comments", CommentLive.Index, :index
    live "/comments/new", CommentLive.New, :new
    live "/comments/:id", CommentLive.Show, :show
    live "/comments/:id/edit", CommentLive.Edit, :edit

    # get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", BlogAppWeb do
    pipe_through :api

    resources "/users", UserController, only: [:index, :show, :create, :update, :delete]
  resources "/posts", PostController, only: [:index, :show, :create, :update, :delete]
  resources "/comments", CommentController, only: [:index, :show, :create, :update, :delete]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:blog_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BlogAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
