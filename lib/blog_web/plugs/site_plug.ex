defmodule BlogWeb.Plugs.SitePlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    {site, persist?} =
      case conn.params["site"] do
        slug when is_binary(slug) ->
          {Blog.Sites.get_by_slug(slug), true}

        _ ->
          # In production, host detection takes priority.
          # Session fallback is only for dev where all sites share localhost.
          host_site = Blog.Sites.get_by_host(conn.host)

          if host_site do
            {host_site, false}
          else
            session_slug = get_session(conn, :site_slug)
            {Blog.Sites.get_by_slug(session_slug || ""), false}
          end
      end

    conn =
      if persist? do
        put_session(conn, :site_slug, site && site.slug)
      else
        conn
      end

    assign(conn, :current_site, site || Blog.Sites.default_site())
  end
end
