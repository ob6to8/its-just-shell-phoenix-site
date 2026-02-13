defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/posts")
  end

  def about(conn, _params) do
    render(conn, :about, page_title: "about")
  end
end
