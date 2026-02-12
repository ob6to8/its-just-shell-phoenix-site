defmodule BlogWeb.PageControllerTest do
  use BlogWeb.ConnCase

  test "GET / redirects to posts", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == "/posts"
  end
end
