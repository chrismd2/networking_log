defmodule NetworkingLog.Nodes do
  alias NetworkingLog.Nodes.Event
  alias NetworkingLog.Nodes.Group
  alias NetworkingLog.Nodes.Interest
  alias NetworkingLog.Nodes.Note
  alias NetworkingLog.Nodes.Person
  alias NetworkingLog.Nodes.Place
  alias NetworkingLog.Repo

  def add(type, data \\ %{}) do
    case type do
      "event" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          %Event{}
          |> Event.changeset(data)
          |> Repo.insert
        end
      "group" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          %Group{}
          |> Group.changeset(data)
          |> Repo.insert
        end
      "interest" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          %Interest{}
          |> Interest.changeset(data)
          |> Repo.insert
        end
      "note" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          %Note{}
          |> Note.changeset(data)
          |> Repo.insert
        end
      "person" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          %Person{}
          |> Person.changeset(data)
          |> Repo.insert
        end
      "place" ->
        if data == %{} do
          IO.write("Need data, should be a map")
        else
          %Place{}
          |> Place.changeset(data)
          |> Repo.insert
        end
      _ ->  IO.write("invalid type: #{type}\n")
            IO.write("\ttry:\tevent\tgroup\tinterest\n")
            IO.write("\t\tnote\tperson\tplace\n")
    end
  end
end
