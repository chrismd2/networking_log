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

    IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end

  @impl true
  def handle_event("select_person", params, socket) do
    IO.inspect(params, label: "params in handle_event(select_person)")

    {:ok, value} = Map.fetch(params, "value")
    {value, _string_tail} = Integer.parse(value)
    IO.inspect(value, label: "value in select_person")

    a_thing = socket.assigns#Map.fetch(, "selected")
    |> IO.inspect(label: "socket.assigns")#Map.fetch(, \"selected\")")
    # {:ok, currently_selected_list} = Map.fetch(a_thing, "selected")
    currently_selected_list = socket.assigns.selected

    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(:selected, [Nodes.read_person(value)] ++ currently_selected_list)

    IO.inspect(socket, label: "new socket in handle_event(select_person)")
    {:noreply, socket}
  end
  @impl true
  def handle_event("delete", params, socket) do
    IO.inspect(params, label: "params in delete")
    # IO.inspect(socket, label: "socket in delete")
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:note, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    IO.inspect(socket, label: "new socket in delete")
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
