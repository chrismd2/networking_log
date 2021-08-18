defmodule NetworkingLogWeb.DataManagementLive do
  use NetworkingLogWeb, :live_view
  use Phoenix.LiveView
  alias NetworkingLog.Nodes

  def dev_test(a_thing) do
    IO.inspect(a_thing, label: "a_thing in DataManagementController")
    "dev test"
  end
  defp format_helper(value) do
    case value do
      nil -> ""
      _   -> " #{value}"
    end
  end
  def format_person_data(_person = %{name: name, phone: phone, email: email}) do
    format_helper(name) <> format_helper(phone) <> format_helper(email)
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
    IO.inspect(params, label: "params in delete")
    # IO.inspect(socket, label: "socket in delete")
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    IO.inspect(socket, label: "new socket")
    {:noreply, socket}
  end
  @impl true
  def handle_event("add_new_person", params, socket) do
    NetworkingLog.Nodes.create_person(params)
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    {:noreply, socket}
  end
  @impl true
  def handle_event("", params, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    {:noreply, socket}
  end
end
