defmodule Blog.Posts.Post do
  @enforce_keys [:id, :title, :body, :date, :description, :tags]
  defstruct [:id, :title, :body, :date, :description, :tags]

  def build(filename, attrs, body) do
    # filename is the full absolute path (with extension), e.g.
    # ".../priv/posts/2026/02-12-hello-world.md"
    # We need the last two path segments: the year dir and the slug file.
    parts = filename |> Path.rootname() |> Path.split()
    [year, month_day_id] = Enum.take(parts, -2)
    [month, day | id_parts] = String.split(month_day_id, "-")
    id = Enum.join(id_parts, "-")
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(
      __MODULE__,
      [id: id, date: date, body: body] ++ Map.to_list(attrs)
    )
  end
end
