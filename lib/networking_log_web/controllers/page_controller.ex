defmodule NetworkingLogWeb.PageController do
  use NetworkingLogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
