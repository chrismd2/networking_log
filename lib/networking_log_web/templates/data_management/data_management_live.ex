defmodule NetworkingLogWeb.DataManagementLive do
  use NetworkingLogWeb, :live_view
  use Phoenix.LiveView
  alias NetworkingLog.Nodes

  def dev_test(conn, params) do
    IO.inspect(conn, label: "conn in DataManagementController")
    IO.inspect(params, label: "params in DataManagementController")
  end

  @impl true
  def mount(_params, _session, socket) do
    mounted_socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(changeset: NetworkingLog.Nodes.Person.changeset(%NetworkingLog.Nodes.Person{}, %{}) )

    IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end

  @impl true
  def handle_event("delete", params, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    {:noreply, socket}
  end
  @impl true
  def handle_event("add_new_person", params, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    {:noreply, socket}
  end
  @impl true
  def handle_event("", params, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    {:noreply, socket}
  end
end
