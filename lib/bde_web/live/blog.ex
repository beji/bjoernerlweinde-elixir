defmodule BdeWeb.BlogLive do
  use Phoenix.LiveView

  @posts_dir Application.app_dir(:bde, "priv/posts")

  def render(%{current_post: nil} = assigns) do
    ~L"""
    <div class="posts">
      <%= for post <- @posts do %>
        <article>
          <h1>
            <%= live_link post[:title], to: BdeWeb.Router.Helpers.live_path(@socket, BdeWeb.BlogLive, %{id: post[:id]}) %>
          </h1>
          <small><%= post[:date] %></small>
          <div>
            <%= Phoenix.HTML.raw(post[:content]) %>
          </div>
        </article>
        <hr />
      <% end %>
    </div>
    """
  end

  def render(assigns) do
    ~L"""
    <div class="post">
        <article>
          <h1>
            <%= @current_post[:title] %>
          </h1>
          <small><%= @current_post[:date] %></small>
          <div>
            <%= Phoenix.HTML.raw(@current_post[:content]) %>
          </div>
        </article>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok,
     socket
     |> assign(posts: Bde.Memoize.memoize({BdeWeb.BlogLive, :get_posts}, []), current_post: nil)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    post = Bde.Memoize.memoize({BdeWeb.BlogLive, :get_post_by_id}, [id])

    {:noreply, socket |> assign(current_post: post)}
  end

  def handle_params(%{}, _url, socket) do
    {:noreply, socket |> assign(current_post: nil)}
  end

  def parse_postfile(file) when is_bitstring(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      cond do
        String.starts_with?(line, "::id") ->
          id = String.replace_prefix(line, "::id ", "")
          Map.put(acc, :id, id)

        String.starts_with?(line, "::title") ->
          title = String.replace_prefix(line, "::title ", "")
          Map.put(acc, :title, title)

        String.starts_with?(line, "::date") ->
          {:ok, date, _} = String.replace_prefix(line, "::date ", "") |> DateTime.from_iso8601()
          Map.put(acc, :date, date)

        true ->
          Map.update(acc, :content, line, fn val -> val <> "\n" <> line end)
      end
    end)
    |> Map.update(:content, "", fn content ->
      Earmark.as_html!(content)
    end)
  end

  def get_post_by_id(id) do
    path = Path.join(@posts_dir, id <> ".md")

    if File.exists?(path) do
      path
      |> File.read!()
      |> parse_postfile()
    else
      ""
    end
  end

  def get_posts do
    true = File.dir?(@posts_dir)
    {:ok, postfiles} = File.ls(@posts_dir)

    postfiles
    |> Enum.map(fn postfile ->
      Path.join(@posts_dir, postfile)
      |> File.read!()
      |> parse_postfile()
    end)
    |> Enum.sort(fn %{date: left}, %{date: right} ->
      DateTime.compare(left, right) == :lt
    end)
    |> Enum.reverse()
  end
end
