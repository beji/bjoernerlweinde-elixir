defmodule BdeWeb.PageController do
  use BdeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def imprint(conn, _params) do
    render(conn, "imprint.html")
  end
end
