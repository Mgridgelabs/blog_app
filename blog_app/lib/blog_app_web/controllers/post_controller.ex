defmodule BlogAppWeb.PostController do
  use BlogAppWeb, :controller

  alias BlogApp.Blogs
  alias BlogApp.Blogs.Post

  action_fallback BlogAppWeb.FallbackController

  def index(conn, _params) do
    posts = Blogs.list_posts()
    render(conn, :index, posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Blogs.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/posts/#{post}")
      |> render(:show, post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    render(conn, :show, post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blogs.get_post!(id)

    with {:ok, %Post{} = post} <- Blogs.update_post(post, post_params) do
      render(conn, :show, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)

    with {:ok, %Post{}} <- Blogs.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
