defmodule BlogWeb.PostHTML do
  use BlogWeb, :html

  embed_templates "post_html/*"

  def format_date(nil), do: "Draft"

  def format_date(datetime) do
    Calendar.strftime(datetime, "%B %d, %Y")
  end
end
