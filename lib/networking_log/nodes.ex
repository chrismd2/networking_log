defmodule NetworkingLog.Nodes do
  alias NetworkingLog.Nodes.Event
  alias NetworkingLog.Nodes.Group
  alias NetworkingLog.Nodes.Interest
  alias NetworkingLog.Nodes.Note
  alias NetworkingLog.Nodes.Person
  alias NetworkingLog.Nodes.Place
  alias NetworkingLog.Repo

  import Ecto.Query

  def add(data) do
    Repo.insert(data)
  end
  def add(type, data \\ %{}) do
    case type do
      "event" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          data = build(data)
          %Event{}
          |> Event.changeset(data)
          |> Repo.insert
        end
      "group" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          data = build(data)
          %Group{}
          |> Group.changeset(data)
          |> Repo.insert
        end
      "interest" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          data = build(data)
          %Interest{}
          |> Interest.changeset(data)
          |> Repo.insert
        end
      "note" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          data = build(data)
          %Note{}
          |> Note.changeset(data)
          |> Repo.insert
        end
      "person" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          data = build(data)
          %Person{}
          |> Person.changeset(data)
          |> Repo.insert
        end
      "place" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          data = build(data)
          %Place{}
          |> Place.changeset(data)
          |> Repo.insert
        end
      _ ->  IO.write("invalid type: #{type}\n")
            IO.write("\ttry:\tevent\tgroup\tinterest\n")
            IO.write("\t\tnote\tperson\tplace\n")
    end
  end
  def get_interests(_data = %{interests: value}) when is_binary(value) do
    Repo.get_by(Interest, name: value)
  end
  defp get_location(_data = %{location: value}) when is_binary(value) do
    Repo.get_by(Location, name: value)
  end
  defp get_notes(_data = %{notes: value}) when is_binary(value) do
    Repo.get_by(Note, text: value)
  end
  def get_people(_data = %{people: value}) when is_binary(value) do
    Repo.get_by(Person, name: value)
  end
  def get_person(_data = %{name: value, interests: interests}) when is_binary(value) do
    Repo.get_by(Person, name: value, interests: interests)
  end
  def get_person(_data = %{name: value}) when is_binary(value) do
    Repo.get_by(Person, name: value)
  end
  defp get_groups(_data = %{groups: value}) when is_binary(value) do
    Repo.get_by(Group, name: value)
  end
  defp get_events(_data = %{events: value}) when is_binary(value) do
    Repo.get_by(Event, name: value)
  end

  ##  These following get_by statements are a bit more complicated and need
  ##  to be more robust, using the given value
  # defp get_text(_data = %{text: value}) when is_binary(value) do
  #   Repo.get_by(Note, text: value)
  # end
  # defp get_phone(_data = %{phone: value}) when is_binary(value) do
  #   Repo.get_by(Person, name: value)
  # end
  # defp get_email(_data = %{email: value}) when is_binary(value) do
  #   Repo.get_by(Person, name: value)
  # end
  # defp get_website(_data = %{website: value}) when is_binary(value) do
  #   Repo.get_by(Group, text: value)
  # end
  # defp get_date(_data = %{date: value}) when is_binary(value) do
  #   Repo.get_by(Event, name: value)
  # end
  # defp get_time(_data = %{time: value}) when is_binary(value) do
  #   Repo.get_by(Event, name: value)
  # end
  def build(data = %{interests: value}) when is_binary(value) do
    Map.update(data, :interests, value, fn eV -> eV = get_interests(data) end)
  end
  def build(data = %{interests: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Interest,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :interests, value, fn ev -> ev = results end)
  end
  def build(data = %{location: value}) when is_binary(value) do
    Map.update(data, :location, value, fn eV -> eV = get_interests(data) end)
  end
  def build(data = %{location: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Location,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :location, value, fn ev -> ev = results end)
  end
  def build(data = %{notes: value}) when is_binary(value) do
    Map.update(data, :notes, value, fn eV -> eV = get_interests(data) end)
  end
  def build(data = %{notes: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Note,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :notes, value, fn ev -> ev = results end)
  end
  def build(data = %{people: value}) when is_binary(value) do
    Map.update(data, :people, value, fn eV -> eV = get_people(data) end)
  end
  def build(data = %{people: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Person,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :people, value, fn ev -> ev = results end)
  end
  # def build(data = %{name: value}) when is_binary(value) do
  #   Map.update(data, :name, value, fn eV -> eV = get_person(data) end)
  # end
  # def build(data = %{name: value = [h|_]}) when is_list(value) do
  #   if is_binary(h) do
  #     results = from(
  #       i in Person,
  #       where: i.name in ^value,
  #       select: i
  #     )
  #     |> Repo.all
  #     Map.update(data, :name, value, fn ev -> ev = results end)
  #   else
  #     IO.write("WARNING: tried to build a non string\n")
  #     data
  #   end
  # end
  def build(data = %{groups: value}) when is_binary(value) do
    Map.update(data, :groups, value, fn eV -> eV = get_groups(data) end)
  end
  def build(data = %{groups: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Group,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :groups, value, fn ev -> ev = results end)
  end
  def build(data = %{events: value}) when is_binary(value) do
    Map.update(data, :events, value, fn eV -> eV = get_events(data) end)
  end
  def build(data = %{events: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Event,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :events, value, fn ev -> ev = results end)
  end
  def build(data = %{interests: value}) when is_binary(value) do
    Map.update(data, :interests, value, fn eV -> eV = get_interests(data) end)
  end
  def build(data = %{interests: value = [h|_]}) when is_binary(h) do
    results = from(
      i in Interest,
      where: i.name in ^value,
      select: i
    )
    |> Repo.all
    Map.update(data, :interests, value, fn ev -> ev = results end)
  end
  def build(data \\ %{}) do
    default_data = %{ interests: [],  location: [], notes:  [],
                      people:    [],  groups:   [], events: [],
                      text:      [],  phone:    [], email:  [],
                      website:   [],  date:     [], time:   []  }
    data = Map.merge(default_data, data)

    # Enum.each( data, fn {k, v} ->
    #   case k do
    #     :interests -> Map.put(new_data, k, "#{v}!")
    #     :location -> Map.put(new_data, k, "#{v}!")
    #     :notes ->  Map.put(new_data, k, "#{v}!")
    #     :people ->    Map.put(new_data, k, "#{v}!")
    #     :groups ->   Map.put(new_data, k, "#{v}!")
    #     :events -> Map.put(new_data, k, "#{v}!")
    #     :text ->      Map.put(new_data, k, "#{v}!")
    #     :phone ->    Map.put(new_data, k, "#{v}!")
    #     :email ->  Map.put(new_data, k, "#{v}!")
    #     :website ->   Map.put(new_data, k, "#{v}!")
    #     :date ->     Map.put(new_data, k, "#{v}!")
    #     :time ->   Map.put(new_data, k, "#{v}!")
    #     :name ->   Map.put(new_data, k, "#{v}!")
    #   end
    # end)
  end

  def update_data(data, map = %{}) do
    update_data(data, [map])
  end
  def update_data(data = %{}, _list = [type = %{} | tail ]) do
    data = Map.merge(data, type)
    if tail != [] do
      update_data(data, tail )
    else
      data
    end
  end
end
