defmodule Blog.Posts do
  import Ecto.Query
  alias Blog.Repo
  alias Blog.Posts.Post

  def list_posts do
    Post
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_published_posts do
    now = DateTime.utc_now()

    Post
    |> where([p], not is_nil(p.published_at) and p.published_at <= ^now)
    |> order_by(desc: :published_at)
    |> Repo.all()
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
