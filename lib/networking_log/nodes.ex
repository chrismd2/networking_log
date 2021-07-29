defmodule NetworkingLog.Nodes do
  alias NetworkingLog.Nodes.Event
  alias NetworkingLog.Nodes.Group
  alias NetworkingLog.Nodes.Interest
  alias NetworkingLog.Nodes.Note
  alias NetworkingLog.Nodes.Person
  alias NetworkingLog.Nodes.Place

  def add(type, data \\ []) do
    case type do
      "event" ->
        if data == [] do
          IO.write("Need data, should be a key value list")
        else
        end
      "group" ->
        if data == [] do
          IO.write("Need data, should be a key value list")
        else
        end
      "interest" ->
        if data == [] do
          IO.write("Need data, should be a key value list")
        else
        end
      "note" ->
        if data == [] do
          IO.write("Need data, should be a key value list")
        else
        end
      "person" ->
        if data == [] do
          IO.write("Need data, should be a key value list")
        else
        end
      "place" ->
        if data == [] do
          IO.write("Need data, should be a key value list")
        else
        end
      _ ->  IO.write("invalid type: #{type}\n")
            IO.write("\ttry:\tevent\tgroup\tinterest\n")
            IO.write("\t\tnote\tperson\tplace\n")
    end
  end
end
