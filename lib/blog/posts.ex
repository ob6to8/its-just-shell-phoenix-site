defmodule Blog.Posts do
  alias Blog.Posts.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:blog, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def list_posts(site_slug) do
    Enum.filter(@posts, &(&1.site == site_slug))
  end

  def get_post!(site_slug, id) do
    Enum.find(@posts, &(&1.site == site_slug and &1.id == id)) ||
      raise Blog.NotFoundError, "post with id=#{id} not found"
  end
end

defmodule Blog.NotFoundError do
  defexception [:message, plug_status: 404]
end
