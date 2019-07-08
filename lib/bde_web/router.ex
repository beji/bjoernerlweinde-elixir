defmodule BdeWeb.Router do
  use BdeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BdeWeb do
    pipe_through :browser

    live "/", BlogLive
    live "/ti", TiLive
    live "/hiit", HiitLive
    live "/pages", PagesLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", BdeWeb do
  #   pipe_through :api
  # end
end
