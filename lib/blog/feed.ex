defmodule Blog.Feed do
  alias Blog.Feed.FeedItem

  use NimblePublisher,
    build: FeedItem,
    from: Application.app_dir(:blog, "priv/feed/**/*.md"),
    as: :feed_items,
    highlighters: [:makeup_elixir]

  @feed_items Enum.sort_by(@feed_items, & &1.date, {:desc, Date})

  def list_feed_items(site_slug) do
    Enum.filter(@feed_items, &(&1.site == site_slug))
  end

  def get_feed_item!(site_slug, id) do
    Enum.find(@feed_items, &(&1.site == site_slug and &1.id == id)) ||
      raise Blog.NotFoundError, "feed item with id=#{id} not found"
  end
end
