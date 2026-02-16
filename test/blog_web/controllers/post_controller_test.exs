defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  describe "index" do
    test "lists posts for the current site", %{conn: conn} do
      conn = get(conn, ~p"/posts?site=its-just-shell")
      assert html_response(conn, 200) =~ "posts"
    end

    test "shows no posts for a site with no content", %{conn: conn} do
      conn = get(conn, ~p"/posts?site=its-just-beam")
      assert html_response(conn, 200) =~ "No posts yet."
    end
  end

  describe "show post" do
    test "shows a post by slug for the correct site", %{conn: conn} do
      conn = get(conn, ~p"/posts/something-big-is-here-humans-as-constancy-anchors?site=its-just-shell")
      assert html_response(conn, 200) =~ "Something Big is Here"
    end

    test "returns 404 for a post on the wrong site", %{conn: conn} do
      assert_raise Blog.NotFoundError, fn ->
        get(conn, ~p"/posts/something-big-is-here-humans-as-constancy-anchors?site=its-just-beam")
      end
    end
  end
end
