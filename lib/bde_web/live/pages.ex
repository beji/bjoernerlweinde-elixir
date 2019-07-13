defmodule BdeWeb.PagesLive do
  use Phoenix.LiveView

  def render(assigns) do
    BdeWeb.PageView.render("imprint.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => "imprint"}, _url, socket) do
    {:noreply, socket |> assign(current_page: "imprint", subtitle: "Impressum / imprint")}
  end

  def handle_params(%{}, _url, socket) do
    {:noreply, socket |> assign(current_page: nil)}
  end
end
