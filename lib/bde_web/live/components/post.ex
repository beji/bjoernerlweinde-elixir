defmodule BdeWeb.Components.Post do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="post">
    <article>
    <%= if @link do %>
    <h1>
    <%= live_link @post[:title], to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.BlogLive, %{id: @post[:id]}) %>
    </h1>
    <% else %>
    <aside>
    <%= live_link "back", to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.BlogLive, %{}) %>
    </aside>
    <h1><%= @post[:title] %></h1>
    <% end %>
    </h1>
    <small><%= @post[:date] %></small>
    <div>
    <%= Phoenix.HTML.raw(@post[:content]) %>
    </div>
    </article>
    </div>
    """
  end
end
