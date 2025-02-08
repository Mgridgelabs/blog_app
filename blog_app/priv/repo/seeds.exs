# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BlogApp.Repo.insert!(%BlogApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# Import necessary modules
alias BlogApp.Repo
alias BlogApp.Accounts.User
alias BlogApp.Blogs.{Post, Comment}

# Create a test user
user =
  Repo.insert!(%User{
    name: "Test User",
    email: "test@example.com",
    hashed_password: Bcrypt.hash_pwd_salt("password")
  })

# Create a post
post =
  Repo.insert!(%Post{
    title: "Welcome to Elixir!",
    body: "Elixir is a functional language designed for maintainable applications.",
    user_id: user.id
  })

# Create a comment (fixing the field name)
comment =
  Repo.insert!(%Comment{
    content: "This is a great post!",  # ✅ Use :content instead of :body
    post_id: post.id,
    user_id: user.id
  })

IO.puts("✅ Database seeded successfully!")
