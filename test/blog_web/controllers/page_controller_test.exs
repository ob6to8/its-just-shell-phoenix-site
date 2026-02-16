defmodule BlogWeb.PageControllerTest do
  use BlogWeb.ConnCase

  test "GET / redirects to posts", %{conn: conn} do
    conn = get(conn, ~p"/?site=its-just-shell")
    assert redirected_to(conn) == "/posts"
  end

  test "GET /about renders about page with site content", %{conn: conn} do
    conn = get(conn, ~p"/about?site=its-just-shell")
    assert html_response(conn, 200) =~ "its just shell"
  end
end
