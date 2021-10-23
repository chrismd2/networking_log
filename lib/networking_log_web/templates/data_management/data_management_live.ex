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

  def selectable_format([], _element) do
    "selectable-btn"
  end
  def selectable_format(list, element) do
    # IO.inspect(element, label: "element in selectable_format")
    # IO.inspect(list, label: "list in selectable_format")
    [h|t] = list
    # IO.inspect(h.id == element.id, label: "bool val in selectable_format")
    if h.id == element.id do
      "selected-btn"
    else
      if t!=[] do
        selectable_format(t, element)
      else
        "selectable-btn"
      end
    end
  end

  @impl true
  def mount(_params, session, socket) do
    user_token = Map.fetch!(session, "user_token")

    mounted_socket = socket
    |> assign(user_token: user_token)
    |> assign(:people, Nodes.get_people(user_token))
    |> assign(:notes, Nodes.get_notes(user_token))
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(changeset_person: NetworkingLog.Nodes.Person.changeset(%NetworkingLog.Nodes.Person{}, %{}) )
    |> assign(changeset_note: NetworkingLog.Nodes.Note.changeset(%NetworkingLog.Nodes.Note{}, %{}) )
    |> assign(selected_person: [])
    |> assign(selected_note: [])

    IO.inspect(mounted_socket, label: "new socket in mount")

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
    # IO.inspect(params, label: "params in handle_event(select_person)")

    {:ok, value} = Map.fetch(params, "value")
    if is_binary(value) do
      {value, _string_tail} = Integer.parse(value)
      # IO.inspect(value, label: "value in select_person")
      currently_selected_person_list = socket.assigns.selected_person
      new_person = Nodes.read_person(value)

      socket = socket
      |> assign(:selected_person, select_person_helper(currently_selected_person_list, new_person))

      # IO.inspect(socket, label: "new socket in handle_event(select_person)")
      {:noreply, socket}
    else
      IO.write("ERROR: value is not a binary\n")
      IO.inspect(value, label: "actual value")
      {:noreply, socket}
    end
  end
  @impl true
  def handle_event("delete", _params, socket) do
    user_token = Map.fetch!(socket.assigns, :user_token)
    # IO.inspect(params, label: "params in delete")
    # IO.inspect(socket, label: "socket in delete")
    # IO.inspect(socket.assigns.selected_person, label: "selected_person buttons for deletion")
    Nodes.delete_person(socket.assigns.selected_person)
    Nodes.delete_note(socket.assigns.selected_note)
    socket = socket
    |> assign(:people, Nodes.get_people(user_token))
    |> assign(:notes, Nodes.get_notes(user_token))
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(:selected_person, [])
    |> assign(:selected_note, [])
    # IO.inspect(socket, label: "new socket in delete")
    {:noreply, socket}
  end
  @impl true
  def handle_event("add_new_person", params, socket) do
    user_token = Map.fetch!(socket.assigns, :user_token)

    uid = NetworkingLog.Accounts.get_user_by_session_token(Map.fetch!(socket.assigns, :user_token))
    uid = uid.id
    pperson = Map.fetch!(params, "person")
    |> Map.put("user_id", uid)
    params = Map.put(params, "person", pperson)

    NetworkingLog.Nodes.create_person(params)
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    socket = socket
    |> assign(:people, Nodes.get_people(user_token))
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    {:noreply, socket}
  end
  @impl true
  def handle_event("add_new_note", params, socket) do
    user_token = Map.fetch!(socket.assigns, :user_token)
    IO.inspect(socket, label: "socket in add new note")
    uid = NetworkingLog.Accounts.get_user_by_session_token(Map.fetch!(socket.assigns, :user_token))
    uid = uid.id
    pnote = Map.fetch!(params, "note")
    |> Map.put("user_id", uid)
    params = Map.put(params, "note", pnote)
    IO.inspect(params, label: "params in add_new_note")
    IO.inspect(socket, label: "socket in add_new_note")
    NetworkingLog.Nodes.create_note(params)

    socket = socket
    |> assign(:people, Nodes.get_people(user_token))
    |> assign(:notes, Nodes.get_notes(user_token))
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)

    # IO.inspect(socket, label: "new socket in add_new_note")
    {:noreply, socket}
  end
  @impl true
  def handle_event("select_note", params, socket) do
    # IO.inspect(params, label: "params in handle_event(select_note)")

    {:ok, value} = Map.fetch(params, "value")
    {value, _string_tail} = Integer.parse(value)
    # IO.inspect(value, label: "value in select_note")
    currently_selected_note_list = socket.assigns.selected_note
    new_note = Nodes.read_note(value)

    socket = socket
    |> assign(:selected_note, select_person_helper(currently_selected_note_list, new_note))

    # IO.inspect(socket, label: "new socket in handle_event(select_note)")
    {:noreply, socket}
  end
  defp update_selected([]) do
    []
  end
  defp update_selected(currently_selected = [record | _]) do
    tail = List.delete(currently_selected, record)
    if tail != [] do
      if Map.has_key?(record, :text) do
        [Nodes.read_note(record.id)] ++ update_selected(tail)
      else
        [Nodes.read_person(record.id)] ++ update_selected(tail)
      end
    else
      if Map.has_key?(record, :text) do
        [Nodes.read_note(record.id)]
      else
        [Nodes.read_person(record.id)]
      end
    end
  end
  defp should_connect?(p_record, n_record) do
    [] == Nodes.read_person_notes(p_record, n_record)
  end
  defp connect_helper(person_list = [p_h | _] , note_list = [n_h | _]) do
    #  BUG: This is a very good spot to spawn processes
    #       to do updates based on different lists concurrently
    person_list = List.delete(person_list, p_h)
    if person_list != [] do
      # IO.inspect(person_list, label: "person list not empty")
      connect_helper(person_list, note_list)
    end
    note_list = List.delete(note_list, n_h)
    if note_list != [] do
      # IO.inspect(note_list, label: "note list not empty")
      connect_helper([p_h], note_list)
    end

    IO.inspect(should_connect?(p_h, n_h), label: "should_connect?(p_h, n_h)")
    if should_connect?(p_h, n_h) do
      Nodes.update_person_notes(p_h, n_h)
    else
      Nodes.delete_person_notes(p_h, n_h)
    end
    # |> IO.inspect(label: "tried updating ptn in connect_helper")
    # IO.inspect(p_h, label: "p_h in connect_helper")
    # IO.inspect(n_h, label: "n_h in connect_helper")
  end
  @impl true
  def handle_event("connect", params, socket) do
    user_token = Map.fetch!(socket.assigns, :user_token)
    assigns = socket.assigns
    # IO.inspect(assigns, label: "assigns in connect")
    IO.inspect(assigns.selected_person, label: "assigns.selected_person in connect")
    IO.inspect(assigns.selected_note, label: "assigns.selected_note in connect")
    connect_helper(assigns.selected_person, assigns.selected_note)
    update_selected(assigns.selected_person)
    # |> IO.inspect(label: "update_selected return value")

    # IO.inspect(assigns.selected_person, label: "originally selected person")

    socket = socket
    |> assign(:people, Nodes.get_people(user_token))
    |> assign(:notes, Nodes.get_notes(user_token))
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    |> assign(:selected_person, update_selected(assigns.selected_person))
    |> assign(:selected_note, update_selected(assigns.selected_note))
    # IO.inspect(socket, label: "modified socket")
    {:noreply, socket}
  end
  @impl true
  def handle_event("", params, socket) do
    user_token = Map.fetch!(socket.assigns, :user_token)
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket")
    socket = socket
    |> assign(:people, Nodes.get_people(user_token))
    |> assign(:notes, Nodes.get_notes(user_token))
    |> assign(:person_to_notes, Nodes.get_all_person_to_notes)
    {:noreply, socket}
  end
end
