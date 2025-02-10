# < gets userid from session,get user from database,assign current user to conn>

defmodule BlogAppWeb.Plugs.AssignUser do
  import Plug.Conn
  alias BlogAppWeb.Repo
  alias BlogAppWeb.User

  def init(default), do: default

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user =
      if user_id do
        Repo.get(User, user_id)
      else
        nil
      end
      assign(conn, :current_user, user)
  end

end
