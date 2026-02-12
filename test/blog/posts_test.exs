defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Posts.Post

  @valid_attrs %{title: "Test Post", body: "Some body content."}
  @update_attrs %{title: "Updated Title", body: "Updated body."}
  @invalid_attrs %{title: nil, body: nil}

  defp post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Posts.create_post()

    post
  end

  test "list_posts/0 returns all posts" do
    post = post_fixture()
    assert Posts.list_posts() == [post]
  end

  test "list_published_posts/0 returns only published posts" do
    _draft = post_fixture(%{title: "Draft"})
    published = post_fixture(%{title: "Published", published_at: ~U[2025-01-01 00:00:00Z]})
    assert Posts.list_published_posts() == [published]
  end

  test "get_post!/1 returns the post" do
    post = post_fixture()
    assert Posts.get_post!(post.id) == post
  end

  test "create_post/1 with valid data creates a post" do
    assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
    assert post.title == "Test Post"
    assert post.body == "Some body content."
  end

  test "create_post/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
  end

  test "update_post/2 with valid data updates the post" do
    post = post_fixture()
    assert {:ok, %Post{} = post} = Posts.update_post(post, @update_attrs)
    assert post.title == "Updated Title"
  end

  test "update_post/2 with invalid data returns error changeset" do
    post = post_fixture()
    assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
    assert post == Posts.get_post!(post.id)
  end

  test "delete_post/1 deletes the post" do
    post = post_fixture()
    assert {:ok, %Post{}} = Posts.delete_post(post)
    assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
  end

  test "change_post/1 returns a changeset" do
    post = post_fixture()
    assert %Ecto.Changeset{} = Posts.change_post(post)
  end
end
