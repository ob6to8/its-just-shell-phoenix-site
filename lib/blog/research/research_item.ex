defmodule Blog.Research.ResearchItem do
  @enforce_keys [:id, :site, :title, :url, :source, :body, :date, :published, :type]
  defstruct [:id, :site, :title, :url, :source, :body, :date, :published, :type]

  def build(filename, attrs, body) do
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
