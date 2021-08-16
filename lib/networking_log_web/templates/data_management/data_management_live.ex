defmodule NetworkingLogWeb.DataManagementLive do
  use NetworkingLogWeb, :live_view
  use Phoenix.LiveView
  alias NetworkingLog.Nodes

  @impl true
  def mount(_params, _session, socket) do
    mounted_socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:people, Nodes.get_all_notes)
    |> assign(:people, Nodes.get_all_person_to_notes)

    IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end
end
