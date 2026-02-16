defmodule BlogWeb.Plugs.DomainRedirect do
  @moduledoc """
  Redirects .com domains to their .dev equivalents with a 301.
  """
  import Plug.Conn

  @redirects %{
    "itsjustshell.com" => "itsjustshell.dev",
    "www.itsjustshell.com" => "www.itsjustshell.dev",
    "itsjustbeam.com" => "itsjustbeam.dev",
    "www.itsjustbeam.com" => "www.itsjustbeam.dev"
  }

  def init(opts), do: opts

  def call(conn, _opts) do
    case Map.get(@redirects, conn.host) do
      nil ->
        conn

      new_host ->
        url = "https://#{new_host}#{conn.request_path}#{qs(conn.query_string)}"

        conn
        |> put_resp_header("location", url)
        |> send_resp(301, "")
        |> halt()
    end
  end

  defp qs(""), do: ""
  defp qs(query_string), do: "?#{query_string}"
end
