defmodule BlogWeb.FeedController do
  use BlogWeb, :controller

  alias Blog.Feed

  def index(conn, _params) do
    feed_items = Feed.list_feed_items(conn.assigns.current_site.slug)
    render(conn, :index, feed_items: feed_items)
  end
end
