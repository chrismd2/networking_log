defmodule NetworkingLogWeb.DataManagementController do
  use NetworkingLogWeb, :controller

  def index(conn, _params) do
    render(conn, "data_management.html")
  end
end
