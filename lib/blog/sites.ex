defmodule Blog.Sites.Site do
  defstruct [:slug, :name, :title_suffix, :domains, :theme, :logo_path, :about_text]
end

defmodule Blog.Sites do
  alias Blog.Sites.Site

  @sites [
    %Site{
      slug: "its-just-shell",
      name: "its-just-shell",
      title_suffix: " - its just shell",
      domains: ["itsjustshell.dev", "www.itsjustshell.dev"],
      theme: %{
        bg: "#282a36",
        text: "#d4d4d8",
        accent: "#60a5fa",
        accent_hover: "#93c5fd",
        gradient_from: "#60a5fa",
        gradient_to: "#c084fc",
        border: "#27272a",
        surface: "#1e1f29",
        text_secondary: "#71717a",
        prose_bg: "#18181b",
        code_color: "#4ade80"
      },
      logo_path: "/images/logo.png",
      about_text: "its just shell"
    },
    %Site{
      slug: "its-just-beam",
      name: "its-just-beam",
      title_suffix: " - its just beam",
      domains: ["itsjustbeam.dev", "www.itsjustbeam.dev"],
      theme: %{
        bg: "#f0ead6",
        text: "#1b2a4a",
        accent: "#1b2a4a",
        accent_hover: "#2d4a7a",
        gradient_from: "#1b2a4a",
        gradient_to: "#4a6fa5",
        border: "#c8c0aa",
        surface: "#e8e2cc",
        text_secondary: "#5a6e8a",
        prose_bg: "#e8e2cc",
        code_color: "#6a5acd"
      },
      logo_path: "/images/its-just-beam/logo.svg",
      about_text: "its just beam — exploring Elixir, OTP, and the BEAM virtual machine."
    },
    %Site{
      slug: "its-just-sound",
      name: "its-just-sound",
      title_suffix: " - its just sound",
      domains: ["itsjustsound.dev", "www.itsjustsound.dev"],
      theme: %{
        bg: "#0f0f1a",
        text: "#d4d4e0",
        accent: "#a855f7",
        accent_hover: "#c084fc",
        gradient_from: "#a855f7",
        gradient_to: "#ec4899",
        border: "#1e1e2e",
        surface: "#161625",
        text_secondary: "#7a7a9a",
        prose_bg: "#12121e",
        code_color: "#c084fc"
      },
      logo_path: "/images/its-just-sound/logo.svg",
      about_text: "its just sound — sonification, music, and observability through audio."
    }
  ]

  def all, do: @sites

  def get_by_host(host) do
    Enum.find(@sites, &(host in &1.domains))
  end

  def get_by_slug(slug) do
    Enum.find(@sites, &(&1.slug == slug))
  end

  def default_site do
    Enum.find(@sites, &(&1.slug == "its-just-shell"))
  end
end
