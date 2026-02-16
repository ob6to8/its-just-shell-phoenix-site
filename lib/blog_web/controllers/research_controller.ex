defmodule BlogWeb.ResearchController do
  use BlogWeb, :controller

  alias Blog.Research

  def index(conn, params) do
    site_slug = conn.assigns.current_site.slug
    all_items = Research.list_research_items(site_slug)
    type_filter = params["type"]

    items =
      if type_filter,
        do: Enum.filter(all_items, &(&1.type == type_filter)),
        else: all_items

    types = Research.list_types(site_slug)
    render(conn, :index, research_items: items, types: types, current_type: type_filter)
  end
end
