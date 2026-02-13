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
      conn = get(conn, ~p"/posts/something-big-is-here-humans-as-constancy-anchors")
      assert html_response(conn, 200) =~ "Something Big is Here"
    end
  end
end
