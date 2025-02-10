defmodule BlogAppWeb.LandingLive do
  use BlogAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-screen flex">
      <!-- Left Side: Image -->
      <div class="w-1/2 h-full bg-cover bg-center bg-no-repeat"
          style="background-image: url('/images/Landing1.png');">
      </div>

      <!-- Right Side: Text Content -->
      <div class="w-1/2 flex flex-col justify-center items-center bg-orange-800 p-10">
        <h1 class="text-5xl font-bold mb-6 text-white">Welcome to BlogApp</h1>
        <p class="text-lg mb-6 text-white">Join us to share and explore amazing posts!</p>

        <div class="space-x-4">
          <.link navigate={~p"/login"} class="bg-blue-500 text-white px-6 py-3 rounded">Login</.link>
          <.link navigate={~p"/register"} class="bg-green-500 text-white px-6 py-3 rounded">Register</.link>
        </div>
      </div>
    </div>
    """
  end
end
