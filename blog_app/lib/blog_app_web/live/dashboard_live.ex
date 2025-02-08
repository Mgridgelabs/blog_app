defmodule BlogAppWeb.DashboardLive do
  use BlogAppWeb, :live_view
  alias BlogApp.Blogs
  alias BlogApp.Blogs.Post

  def mount(_params, _session, socket) do
    posts = Blogs.list_posts() |> BlogApp.Repo.preload(:comments) # ✅ Preload comments
    {:ok, assign(socket, posts: posts, form: to_form(Blogs.change_post(%Post{})))}
  end


  def handle_event("delete", %{"id" => id}, socket) do
    post = Blogs.get_post!(id)
    {:ok, _} = Blogs.delete_post(post)

    {:noreply, assign(socket, posts: Blogs.list_posts())}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6 bg-gray-100 min-h-screen">

      <!-- User Info -->
      <div class="flex items-center gap-3 bg-white p-4 rounded-lg shadow">
        <img src="/images/user-icon.png" alt="User Icon" class="w-12 h-12 rounded-full" />
        <p class="text-lg font-semibold">Welcome, User</p>
      </div>

      <!-- Create Post Form -->
      <div class="bg-white p-6 mt-6 rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-4">Create a New Post</h2>
        <.form for={@form} phx-submit="create" class="space-y-4">
          <input type="text" name="title" placeholder="Title" required class="w-full px-4 py-2 border rounded-md" />
          <textarea name="body" placeholder="Write your post..." required class="w-full px-4 py-2 border rounded-md"></textarea>
          <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">Create Post</button>
        </.form>
      </div>

      <!-- Post List -->
      <div class="mt-6">
        <h2 class="text-xl font-semibold">Your Posts</h2>

        <div class="space-y-4 mt-4">
          <%= for post <- @posts do %>
            <div class="bg-white p-4 rounded-lg shadow">
              <h3 class="text-lg font-semibold"><%= post.title %></h3>
              <p class="text-gray-700"><%= post.body %></p>

              <div class="flex gap-4 mt-3">
                <a href={"/posts/#{post.id}"} class="text-blue-500 hover:underline">Show</a>
                <a href={"/posts/#{post.id}/edit"} class="text-yellow-500 hover:underline">Edit</a>
                <button phx-click="delete" phx-value-id={post.id} class="text-red-500 hover:underline">Delete</button>
              </div>
            </div>
          <% end %>
        </div>
      </div>

    </div>
    """
  end
end
