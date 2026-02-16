defmodule BlogWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use BlogWeb, :controller` and
  `use BlogWeb, :live_view`.
  """
  use BlogWeb, :html

  embed_templates "layouts/*"

  def theme_style(theme) do
    "--bg:#{theme.bg};--text:#{theme.text};--accent:#{theme.accent};--accent-hover:#{theme.accent_hover};--gradient-from:#{theme.gradient_from};--gradient-to:#{theme.gradient_to};--border:#{theme.border};--surface:#{theme.surface};--text-secondary:#{theme.text_secondary};--prose-bg:#{theme.prose_bg};--code-color:#{theme.code_color}"
  end
end
