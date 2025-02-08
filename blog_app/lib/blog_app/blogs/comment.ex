defmodule BlogApp.Blogs.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :user_id, :id

    belongs_to :post, BlogApp.Blogs.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :post_id, :user_id])
    |> validate_required([:content, :post_id, :user_id])  
  end
end
