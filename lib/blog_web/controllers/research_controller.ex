defmodule BlogWeb.ResearchController do
  use BlogWeb, :controller

  alias Blog.Research

  def index(conn, _params) do
    research_items = Research.list_research_items(conn.assigns.current_site.slug)
    render(conn, :index, research_items: research_items)
  end
end
