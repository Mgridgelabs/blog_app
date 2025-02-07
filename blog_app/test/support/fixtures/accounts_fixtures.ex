defmodule BlogApp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BlogApp.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> BlogApp.Accounts.create_user()

    user
  end
end
