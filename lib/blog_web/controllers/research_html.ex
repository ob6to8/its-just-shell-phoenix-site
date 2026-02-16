defmodule BlogWeb.ResearchHTML do
  use BlogWeb, :html

  embed_templates "research_html/*"

  def format_date(%Date{} = date) do
    Calendar.strftime(date, "%B %d, %Y")
  end
end
