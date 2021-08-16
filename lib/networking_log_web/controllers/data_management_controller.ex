defmodule NetworkingLogWeb.DataManagementController do
  use NetworkingLogWeb, :controller

  def index(conn, params) do
    render(conn, "data_management_live.html")
  end

  @impl true
  def mount(_params, _session, socket) do
    IO.write("\n\nFLAG\n\n")
    mounted_socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:notes, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)

    IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end
end
