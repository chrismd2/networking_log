defmodule NetworkingLogWeb.DataManagementController do
  use NetworkingLogWeb, :controller

  def index(conn, params) do
    render(conn, "data_management_live.html")
  end

  def recieve(conn, params) do
    IO.inspect(conn, label: "conn in DataManagementController")
    IO.inspect(params, label: "params in DataManagementController")
    conn
    |> put_status(201)
    |> json(%{})
  end
end
