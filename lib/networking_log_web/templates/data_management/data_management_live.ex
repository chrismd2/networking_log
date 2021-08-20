defmodule NetworkingLogWeb.DataManagementLive do
  use NetworkingLogWeb, :live_view
  use Phoenix.LiveView
  alias NetworkingLog.Nodes

  def dev_test(a_thing) do
    IO.inspect(a_thing, label: "a_thing in DataManagementController")
    "dev test"
  end
  def format_helper(value) do
    case value do
      nil -> ""
      _   -> " #{value}"
    end
  end
  def format_person_data(_person = %{name: name, phone: phone, email: email}) do
    format_helper(name)# <> format_helper(phone) <> format_helper(email)
  end
  def format_person_data(_person = %{name: name, phone: phone, email: email}, info_card? = true) do
    "#{format_helper(name)} \n\t#{format_helper(phone)} \n\t#{format_helper(email)}"
  end

  @impl true
  def mount(_params, _session, socket) do
    mounted_socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:notes, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(changeset_person: NetworkingLog.Nodes.Person.changeset(%NetworkingLog.Nodes.Person{}, %{}) )
    |> assign(changeset_note: NetworkingLog.Nodes.Note.changeset(%NetworkingLog.Nodes.Note{}, %{}) )
    |> assign(selected_person: [])
    |> assign(selected_note: [])

    # IO.inspect(mounted_socket, label: "new socket in mount")

    {:ok, mounted_socket}
  end

  defp select_person_helper(currently_selected_person_list, new_person) do
    if Enum.member?(currently_selected_person_list, new_person) do
      List.delete(currently_selected_person_list, new_person)
    else
      [new_person]++currently_selected_person_list
    end
  end
  @impl true
  def handle_event("select_person", params, socket) do
    IO.inspect(params, label: "params in handle_event(select_person)")

    {:ok, value} = Map.fetch(params, "value")
    {value, _string_tail} = Integer.parse(value)
    IO.inspect(value, label: "value in select_person")
    currently_selected_person_list = socket.assigns.selected_person
    new_person = Nodes.read_person(value)

    socket = socket
    |> assign(:selected_person, select_person_helper(currently_selected_person_list, new_person))

    IO.inspect(socket, label: "new socket in handle_event(select_person)")
    {:noreply, socket}
  end
  @impl true
  def handle_event("delete", _params, socket) do
    # IO.inspect(params, label: "params in delete")
    # IO.inspect(socket, label: "socket in delete")
    IO.inspect(socket.assigns.selected_person, label: "selected_person buttons for deletion")
    Nodes.delete_person(socket.assigns.selected_person)
    Nodes.delete_note(socket.assigns.selected_note)
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:notes, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(:selected_person, [])
    |> assign(:selected_note, [])
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
  def handle_event("add_new_note", params, socket) do
    IO.inspect(params, label: "params in add_new_note")
    IO.inspect(socket, label: "socket in add_new_note")
    NetworkingLog.Nodes.create_note(params)

    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:notes, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)

    IO.inspect(socket, label: "new socket in add_new_note")
    {:noreply, socket}
  end
  @impl true
  def handle_event("select_note", params, socket) do
    IO.inspect(params, label: "params in handle_event(select_note)")

    {:ok, value} = Map.fetch(params, "value")
    {value, _string_tail} = Integer.parse(value)
    IO.inspect(value, label: "value in select_note")
    currently_selected_note_list = socket.assigns.selected_note
    new_note = Nodes.read_note(value)

    socket = socket
    |> assign(:selected_note, select_person_helper(currently_selected_note_list, new_note))

    IO.inspect(socket, label: "new socket in handle_event(select_note)")
    {:noreply, socket}
  end
  @impl true
  def handle_event("", params, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    socket = socket
    |> assign(:people, Nodes.get_all_people)
    |> assign(:notes, Nodes.get_all_notes)
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    {:noreply, socket}
  end
end
