defmodule BlogWeb.PostHTML do
  use BlogWeb, :html

  embed_templates "post_html/*"

  def format_date(%Date{} = date) do
    Calendar.strftime(date, "%B %d, %Y")
  end
end
