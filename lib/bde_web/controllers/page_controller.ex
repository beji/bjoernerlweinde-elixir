defmodule BdeWeb.PageController do
  use BdeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
