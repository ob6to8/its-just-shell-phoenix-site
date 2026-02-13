defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  describe "index" do
    test "lists posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "posts"
    end
  end

  describe "show post" do
    test "shows a post by slug", %{conn: conn} do
      conn = get(conn, ~p"/posts/hello-world")
      assert html_response(conn, 200) =~ "Hello World"
    end
  end
end
