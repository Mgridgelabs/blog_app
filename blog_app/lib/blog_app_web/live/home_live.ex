defmodule BlogAppWeb.HomeLive do
  use BlogAppWeb, :live_view

  alias BlogApp.Blogs

  def mount(_params, _session, socket) do
    posts = Blogs.list_posts()  # Fetch posts with preloaded comments
    {:ok, assign(socket, posts: posts)}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-6">
      <h1 class="text-3xl font-bold mb-4">Welcome to the Blog</h1>

      <div>
        <%= for post <- @posts do %>
          <div class="border p-4 mb-4 rounded shadow-lg">
            <h2 class="text-2xl font-semibold"><%= post.title %></h2>
            <p class="text-gray-500 text-sm">By <%= post.user.name %></p>
            <p class="text-gray-700"><%= post.body %></p>

            <h3 class="mt-3 font-bold">Comments:</h3>
            <ul class="list-disc list-inside">
              <%= for comment <- post.comments do %>
                <li class="ml-4 text-gray-600">- <%= comment.content %></li>
              <% end %>
            </ul>
          </div>
        <% end %>
      </div>

      <div class="mt-6">
        <button phx-click="go_dashboard" class="bg-blue-500 text-white px-4 py-2 rounded">
          Go to Dashboard
        </button>
      </div>
    </div>
    """
  end

  def handle_event("go_dashboard", _params, socket) do
    {:noreply, push_navigate(socket, to: "/dashboard")}
  end
end
