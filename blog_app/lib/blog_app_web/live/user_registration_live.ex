defmodule BlogAppWeb.UserRegistrationLive do
  use BlogAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-screen flex flex-col justify-center items-center">
      <h1 class="text-4xl font-bold">Register</h1>
      <form phx-submit="register" class="mt-6 flex flex-col">
        <input type="text" name="username" placeholder="Username" class="border p-2 rounded mb-3" />
        <input type="text" name="email" placeholder="Email" class="border p-2 rounded mb-3"/>
        <input type="password" name="password" placeholder="Password" class="border p-2 rounded mb-3"/>
        <button type="submit" class="bg-green-500 text-white px-6 py-3 rounded">Sign Up</button>

      </form>
    </div>
    """
  end

  def handle_event("register", %{"email" => email, "password" => password, "username" => name}, socket) do
    case BlogApp.Accounts.create_user(%{"email" => email, "password" => password, "name" => name}) do
      {:ok, user} ->
        IO.puts("user registered successfully")
        {:noreply, push_navigate(socket, to: "/login")} # Redirect to login after successful registration

      {:error, changeset} ->
        IO.inspect("user registration failed")

        {:noreply, assign(socket, changeset: changeset)} # Show validation errors
    end
    end
end
