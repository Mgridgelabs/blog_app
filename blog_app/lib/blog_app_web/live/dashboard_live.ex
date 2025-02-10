defmodule BlogAppWeb.DashboardLive do
  use BlogAppWeb, :live_view
  import Ecto.Query
  alias BlogApp.{Repo, Blogs, Accounts}
  alias BlogApp.Blogs.Post
  alias BlogApp.Accounts.User

  def mount(_params, session, socket) do
    case session["user_id"] do
      nil ->
        {:ok, socket |> put_flash(:error, "Please log in") |> push_navigate(to: "/login")}

      user_id ->
        case Repo.get(User, user_id) do
          nil ->
            {:ok, socket |> put_flash(:error, "User not found") |> push_navigate(to: "/login")}

          user ->
            posts = Repo.all(from p in Post, where: p.user_id == ^user.id)
            {:ok, assign(socket, current_user: user, posts: posts)}
        end
    end
  end




  def handle_event("delete", %{"id" => id}, socket) do
    with %{user: user} <- socket.assigns,
         post <- Blogs.get_post!(id),
         true <- post.user_id == user.id do
      {:ok, _} = Blogs.delete_post(post)
      posts = Repo.all(from p in Post, where: p.user_id == ^user.id)
      {:noreply, assign(socket, posts: posts)}
    else
      _ -> {:noreply, socket |> put_flash(:error, "Unable to delete post")}
    end
  end

  def handle_event("upload_avatar", %{"avatar" => %Plug.Upload{} = upload}, socket) do
    user = socket.assigns.user

    # Generate a unique filename
    filename = "#{user.id}_#{upload.filename}"
    upload_path = Path.join(["priv/static/uploads", filename])

    # Save the uploaded file
    case File.cp(upload.path, upload_path) do
      :ok ->
        changeset = User.changeset(user, %{avatar_url: "/uploads/#{filename}"})

        case Repo.update(changeset) do
          {:ok, updated_user} ->
            {:noreply, assign(socket, user: updated_user)}

          {:error, _changeset} ->
            {:noreply, socket |> put_flash(:error, "Failed to update avatar")}
        end

      {:error, _reason} ->
        {:noreply, socket |> put_flash(:error, "Failed to upload avatar")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6 bg-gray-100 min-h-screen">
      <!-- User Info -->
      <div class="flex items-center gap-3 bg-white p-4 rounded-lg shadow">
        <img src={@user.avatar_url || "/images/default-avatar.png"} alt="User Icon" class="w-12 h-12 rounded-full object-cover" />
        <p class="text-lg font-semibold">Welcome, <%= @user.name %></p>
      </div>

      <!-- Avatar Upload Form -->
      <div class="bg-white p-4 mt-4 rounded-lg shadow">
        <h3 class="text-md font-semibold">Change Avatar</h3>
        <.form phx-submit="upload_avatar" enctype="multipart/form-data">
          <input type="file" name="avatar" accept="image/*" class="mt-2" />
          <button type="submit" class="ml-2 bg-blue-500 text-white px-4 py-2 rounded">Upload</button>
        </.form>
      </div>

      <!-- Create Post Form -->
      <div class="bg-white p-6 mt-6 rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-4">Create a New Post</h2>
        <.form phx-submit="create" class="space-y-4">
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
