defmodule Blog.Posts.Post do
  @enforce_keys [:id, :site, :title, :body, :date, :description, :tags]
  defstruct [:id, :site, :title, :body, :date, :description, :tags]

  def build(filename, attrs, body) do
    # filename is the full absolute path, e.g.
    # ".../priv/posts/its-just-shell/2026/02-12-hello-world.md"
    parts = filename |> Path.rootname() |> Path.split()
    [site_slug, year, month_day_id] = Enum.take(parts, -3)
    [month, day | id_parts] = String.split(month_day_id, "-")
    id = Enum.join(id_parts, "-")
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(
      __MODULE__,
      [id: id, site: site_slug, date: date, body: body] ++ Map.to_list(attrs)
    )
  end
end
