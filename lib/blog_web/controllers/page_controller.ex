defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/posts")
  end
end
