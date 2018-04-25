defmodule MeshingtonWeb.PageController do
  use MeshingtonWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
