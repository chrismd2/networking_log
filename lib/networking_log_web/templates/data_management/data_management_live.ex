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
    format_helper(name)# <> format_helper(phone) <> format_helper(email)
  end

  @impl true
  def mount(_params, _session, socket) do
    mounted_socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(changeset: NetworkingLog.Nodes.Person.changeset(%NetworkingLog.Nodes.Person{}, %{}) )
    |> assign(selected: [])

    # IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end

  defp select_person_helper(currently_selected_list, new_person) do
    if Enum.member?(currently_selected_list, new_person) do
      List.delete(currently_selected_list, new_person)
    else
      [new_person]++currently_selected_list
    end
  end
  @impl true
  def handle_event("select_person", params, socket) do
    IO.inspect(params, label: "params in handle_event(select_person)")

    {:ok, value} = Map.fetch(params, "value")
    {value, _string_tail} = Integer.parse(value)
    # IO.inspect(value, label: "value in select_person")
    currently_selected_list = socket.assigns.selected
    new_person = Nodes.read_person(value)

    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(:selected, select_person_helper(currently_selected_list, new_person))

    # IO.inspect(socket, label: "new socket in handle_event(select_person)")
    {:noreply, socket}
  end
  @impl true
  def handle_event("delete", _params, socket) do
    # IO.inspect(params, label: "params in delete")
    # IO.inspect(socket, label: "socket in delete")
    IO.inspect(socket.assigns.selected, label: "selected buttons for deletion")
    Nodes.delete_person(socket.assigns.selected)
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(:selected, [])
    IO.inspect(socket, label: "new socket in delete")
    {:noreply, socket}
  end
  @impl true
  def handle_event("add_new_person", params, socket) do
    NetworkingLog.Nodes.create_person(params)
    # IO.inspect(params, label: "params")
    # IO.inspect(socket, label: "socket")
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
