defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Posts

  def index(conn, _params) do
    posts = Posts.list_posts(conn.assigns.current_site.slug)
    render(conn, :index, posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(conn.assigns.current_site.slug, id)
    render(conn, :show, post: post)
  end
end
