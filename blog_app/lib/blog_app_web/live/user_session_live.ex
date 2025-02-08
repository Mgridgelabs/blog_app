defmodule BlogAppWeb.UserSessionLive do
  use BlogAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-screen flex flex-col justify-center items-center">
      <h1 class="text-4xl font-bold">Login</h1>

      <%!-- <%= if @error_message do %>
        <p class="text-red-500"><%= @error_message %></p>
      <% end %> --%>

      <form phx-submit="login" class="mt-6 flex flex-col">
        <input type="text" name="email" placeholder="Email" class="border p-2 rounded mb-3"/>
        <input type="password" name="password" placeholder="Password" class="border p-2 rounded mb-3"/>
        <button type="submit" class="bg-blue-500 text-white px-6 py-3 rounded">Login</button>
      </form>
    </div>
    """
  end


  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case BlogApp.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        IO.puts("✅ Login successful for #{email}")
        {:noreply, push_navigate(socket, to: "/home")}

      {:error, reason} ->
        IO.puts("❌ Login failed for #{email}")
        {:noreply, assign(socket, :error_message, "Invalid email or password")}
    end
  end

end
