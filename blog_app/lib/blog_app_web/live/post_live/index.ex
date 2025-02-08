##list all posts
#mount/3-fetcches all post
#render/1-display post titles with links
defmodule BlogAppWeb.PostLive.Index do
  use BlogAppWeb, :live_view

  alias BlogApp.Blogs
  alias BlogApp.Blogs.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :posts, list_posts())}
  end

  def list_posts do
    Blogs.list_posts()
  end
  
  def render (assigns) do
    ~H"""
    <div>
    <h1>Posts</h1>
    <ul>
    <%= for post <- @posts do %>
    <li><%= live_patch post.tittle, to: Routes.post_show_path(@socket, :show, post.id) %>
    </li>
    <% end %>
    </ul>
    </div>
    """
  end
end
