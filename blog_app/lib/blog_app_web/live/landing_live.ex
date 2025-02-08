defmodule BlogAppWeb.LandingLive do
  use BlogAppWeb, :live_view


  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-screen flex flex-col justify-center items-center bg-gray-100">
      <h1 class="text-5xl font-bold mb-6">Welcome to BlogApp</h1>
      <p class="text-lg mb-6">Join us to share and explore amazing posts!</p>

      <div class="space-x-4">
        <.link navigate={~p"/login"} class="bg-blue-500 text-white px-6 py-3 rounded">Login</.link>
        <.link navigate={~p"/register"} class="bg-green-500 text-white px-6 py-3 rounded">Register</.link>
      </div>
    </div>
    """
  end
end
