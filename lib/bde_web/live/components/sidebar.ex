defmodule BdeWeb.Components.Sidebar do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <section class="sidebar">
    <header>
    <h1>
    <%= live_link "Bjoernerlwein.de", to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.BlogLive, %{}) %>
    </h1>
    <%= if assigns[:subtitle] do %>
    <small class="sub-header"><%= @subtitle %></small>
    <% end %>
    </header>
    <nav class="navigation">
    <h2>Pages</h2>
    <ul>
    <li><%= live_link "TI faction shuffle thing", to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.TiLive, %{}) %></li>
    <li><%= live_link "HIIT Timer", to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.HiitLive, %{}) %></li>
    <li><%= live_link "Impressum / imprint", to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.PagesLive, %{id: "imprint"}) %>
    </ul>
    </nav>
    <footer><a href="//creativecommons.org/licenses/by-sa/4.0/" rel="license"><img src="//i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Creative Commons License" style="border-width: 0;"></a><br><span>bjoernerlwein.de</span> by <a href="//bjoernerlwein.de" rel="cc:attributionURL">Björn Erlwein</a> is licensed under a <a href="//creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons Attribution-ShareAlike 4.0 International License</a>.</footer>
    </section>
    """
  end
end
