defmodule Blog.Research do
  alias Blog.Research.ResearchItem

  use NimblePublisher,
    build: ResearchItem,
    from: Application.app_dir(:blog, "priv/research/**/*.md"),
    as: :research_items,
    highlighters: [:makeup_elixir]

  @research_items Enum.sort_by(@research_items, & &1.date, {:desc, Date})

  def list_research_items(site_slug) do
    Enum.filter(@research_items, &(&1.site == site_slug))
  end

  def get_research_item!(site_slug, id) do
    Enum.find(@research_items, &(&1.site == site_slug and &1.id == id)) ||
      raise Blog.NotFoundError, "research item with id=#{id} not found"
  end
end
