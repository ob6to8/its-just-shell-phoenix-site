defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Posts

  @create_attrs %{title: "Test Post", body: "This is test content.", published_at: ~U[2026-01-01 00:00:00Z]}
  @update_attrs %{title: "Updated Post", body: "Updated content."}
  @invalid_attrs %{title: nil, body: nil}

  defp create_post(_) do
    {:ok, post} = Posts.create_post(@create_attrs)
    %{post: post}
  end

  describe "index" do
    test "lists published posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post: @create_attrs)
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == "/posts/#{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "show post" do
    setup [:create_post]

    test "shows the post", %{conn: conn, post: post} do
      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ post.title
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing", %{conn: conn, post: post} do
      conn = get(conn, ~p"/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put(conn, ~p"/posts/#{post}", post: @update_attrs)
      assert redirected_to(conn) == "/posts/#{post.id}"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, ~p"/posts/#{post}", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, ~p"/posts/#{post}")
      assert redirected_to(conn) == "/posts"
    end
  end
end
