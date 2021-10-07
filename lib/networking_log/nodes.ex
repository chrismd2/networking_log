defmodule NetworkingLog.Nodes do
  alias NetworkingLog.Nodes.Note
  alias NetworkingLog.Nodes.Person
  alias NetworkingLog.Nodes.PersonToNotes
  alias NetworkingLog.Repo

  import Ecto.Query

  def get_note(data = %{text: value}) when is_binary(value) do
    [record] = read_note(data)
    record
  end
  def get_person(data = %{name: value}) when is_binary(value) do
    [record] = read_person(data)
    record
  end
  def get_notes_for_person(data = %{name: value}) when is_binary(value) do
    read_person_notes(%{person: data})
  end
  def get_people_for_note(data = %{text: value}) when is_binary(value) do
    read_person_notes(%{notes: data})
  end
  def get_all_people do
    q = from p in Person
    Repo.all(q)
  end
  def get_all_notes do
    q = from n in Note
    Repo.all(q)
  end
  def get_all_person_to_notes do
    q = from ptn in PersonToNotes
    Repo.all(q)
  end

  def update_data(data, map = %{}) do
    update_data(data, [map])
  end
  def update_data(data = %{}, _list = [type = %{} | tail ]) do
    data = Map.merge(data, type)
    if tail != [] do
      update_data(data, tail)
    else
      data
    end
  end

  def create_person(data) when is_map(data) do
    if(!Map.has_key?(data, :name)) do
      if(!Map.has_key?(data, "person")) do
        IO.write("data is invalid\n")
        IO.inspect(data, label: "data provided")
      else
        {:ok, data} = Map.fetch(data, "person")
        update_data(%{}, Enum.map(data, fn {k, v} -> %{String.to_atom(k) => v} end))
        |> create_person
      end
    else
      %Person{}
      |> Person.changeset(data)
      |> Repo.insert
    end
  end
  def read_person(data = %{name: name_value, phone: phone_value, email: email_value}) do
    if(!(is_nil(name_value) || is_nil(phone_value) || is_nil(email_value) ) ) do
      q = from p in Person,
          where:  p.name == ^name_value and
          p.phone == ^phone_value and
          p.email == ^email_value
      Repo.all(q)
    else
      if(is_nil(name_value)) do
        read_person(%{phone: phone_value, email: email_value})
      else
        if(is_nil(phone_value)) do
          read_person(%{name: name_value, email: email_value})
        else
          read_person(%{name: name_value, phone: phone_value})
        end
      end
    end
  end
  def read_person(data = %{name: name_value, phone: phone_value}) do
    if(!(is_nil(name_value) || is_nil(phone_value) ) ) do
      q = from p in Person,
          where:  p.name == ^name_value and
          p.phone == ^phone_value
      Repo.all(q)
    else
      if is_nil(name_value) do
        read_person(%{phone: phone_value})
      else
        read_person(%{name: name_value})
      end
    end
  end
  def read_person(data = %{name: name_value, email: email_value}) do
    if(!(is_nil(name_value) || is_nil(email_value) ) ) do
      q = from p in Person,
          where:  p.name == ^name_value and
          p.email == ^email_value
      Repo.all(q)
    else
      if is_nil(name_value) do
        read_person(%{email: email_value})
      else
        read_person(%{name: name_value})
      end
    end
  end
  def read_person(data = %{phone: phone_value, email: email_value}) do
    if(!(is_nil(phone_value) || is_nil(email_value) ) ) do
      q = from p in Person,
          where:  p.phone == ^phone_value and
          p.email == ^email_value
      Repo.all(q)
    else
      if(is_nil(phone_value)) do
        read_person(%{email: email_value})
      else
        read_person(%{phone: phone_value})
      end
    end
  end
  def read_person(data = %{ phone: phone_value}) do
    q = from p in Person,
        where:  p.phone == ^phone_value
    Repo.all(q)
  end
  def read_person(data = %{email: email_value}) do
    q = from p in Person,
        where:  p.email == ^email_value
    Repo.all(q)
  end
  def read_person(data = %{name: name_value}) do
    q = from p in Person,
        where:  p.name == ^name_value
    Repo.all(q)
  end
  def read_person(data) when is_integer(data) do
    result = Repo.get(Person, data)
    if is_nil(result) do
      IO.write("no result found for #{data}")
    else
      Repo.preload(result, :notes)
    end
  end
  def read_person(data) do
    IO.write("data is invalid\n")
    IO.inspect(data, label: "data provided")
  end
  # def read_person(data) when is_list(data) do
  #   if(!Map.has_key?(data, :name)) do
  #     IO.write("data is invalid\n")
  #     IO.inspect(data, label: "data provided")
  #   else
  #     Repo.get_by(Person, name: value)
  #   end
  # end
  def update_person(old_data, new_data) when is_map(old_data) do
    if(!Map.has_key?(old_data, :name) || !Map.has_key?(new_data, :name)) do
      IO.write("data is invalid\n")
      IO.inspect(old_data, label: "old_data provided")
      IO.inspect(new_data, label: "new_data provided")
    else
      [record] = read_person(old_data)
      Person.changeset(record, new_data)
      |> Repo.update
    end
  end
  def delete_person([]) do
    :done
  end
  def delete_person(_data = [h | t]) do
    delete_person(%{
      name: h.name,
      phone: h.phone,
      email: h.email  })
    if t!=[] do
      delete_person(t)
    end
  end
  def delete_person(data) when is_map(data) do
    if(!Map.has_key?(data, :name)) do
      if(!Map.has_key?(data, "person")) do
        IO.write("data is invalid\n")
        IO.inspect(data, label: "data provided")
      else
        {:ok, data} = Map.fetch(data, "person")
        update_data(%{}, Enum.map(data, fn {k, v} -> %{String.to_atom(k) => v} end))
        |> delete_person
      end
    else
      [record | _tail] = read_person(data)
      Person.changeset(record, %{})
      |> Repo.delete
    end
  end

  def create_note(data) when is_map(data) do
    if(!Map.has_key?(data, :text)) do
      if(!Map.has_key?(data, "note")) do
        IO.write("data is invalid\n")
        IO.inspect(data, label: "data provided")
      else
        {:ok, data} = Map.fetch(data, "note")
        update_data(%{}, Enum.map(data, fn {k, v} -> %{String.to_atom(k) => v} end))
        |> create_note
      end
    else
      %Note{}
      |> Note.changeset(data)
      |> Repo.insert
    end
  end
  def read_note(data) when is_integer(data) do
    # Repo.all(from n in Note, where: n.text == ^value)
    result = Repo.get(Note, data)
    if is_nil(result) do
      IO.write("no result found for #{data}")
    else
      Repo.preload(result, :people)
    end
  end
  def read_note(data = %{text: value}) when is_binary(value) do
    Repo.all(from n in Note, where: n.text == ^value)
  end
  def update_note(old_data, new_data) when is_map(old_data) do
    if(!Map.has_key?(old_data, :text) || !Map.has_key?(new_data, :text)) do
      IO.write("data is invalid\n")
      IO.inspect(old_data, label: "old_data provided")
      IO.inspect(new_data, label: "new_data provided")
    else
      get_note(old_data)
      |> Note.changeset(new_data)
      |> Repo.update
    end
  end
  def delete_note([]) do
    :done
  end
  def delete_note(_data = [h | t]) do
    if Map.has_key?(h, :id) do
      Repo.delete(Repo.get!(Note, h.id))
    else
      delete_note(%{text: h.text})
    end
    if t!=[] do
      delete_note(t)
    end
  end
  def delete_note(data) when is_map(data) do
    IO.inspect(data, label: "data in delete_note")
    if(!Map.has_key?(data, :text)) do
      IO.write("data is invalid\n")
      IO.inspect(data, label: "data provided")
    else
      note = get_note(data)
      IO.inspect(note, label: "note")
      note
      |> Note.changeset(%{})
      |> Repo.delete
    end
  end

  def create_person_notes(person, note = %{text: text}) do
    people = read_person(person)
    notes = read_note(note)
    [n_record] = notes
    # n_record = Repo.preload(n_record, :people)
    # people = people ++ n_record.people

    n_record
    |> Repo.preload(:people)
    |> Note.changeset_assoc(people)
    |> Repo.update
  end
  def read_person_notes(person, notes = %{text: text})  do
    [p_record] = read_person(person)
    [n_record] = read_note(notes)
    q = from ptn in PersonToNotes,
        where:  ptn.person_id == ^p_record.id and
                ptn.note_id   == ^n_record.id
    # IO.inspect(q, label: "ptn query")
    Repo.all(q)
  end
  def read_person_notes(%{person: person, notes: notes = %{text: text}})  do
    read_person_notes(person, notes)
  end
  def read_person_notes(%{person: person})  do
    [p_record] = read_person(person)
    q = from ptn in PersonToNotes,
        where:  ptn.person_id == ^p_record.id
    # IO.inspect(q, label: "ptn query")
    Repo.all(q)
  end
  def read_person_notes(%{notes: notes = %{text: text}})  do
    [n_record] = read_note(notes)
    q = from ptn in PersonToNotes,
        where:  ptn.note_id   == ^n_record.id
    # IO.inspect(q, label: "ptn query")
    Repo.all(q)
  end
  def update_person_notes(person, note = %{text: text})  do
    people = read_person(person)
    notes = read_note(note)
    [n_record] = notes
    n_record = Repo.preload(n_record, :people)
    people = people ++ n_record.people

    n_record
    |> Note.changeset_assoc(people)
    |> Repo.update
  end
  def delete_person_notes(person, notes = %{text: _text})  do
    [ptn] = read_person_notes(person, notes)
    Repo.delete(ptn)
    # |> Enum.each( fn(ptn) ->
    #                 PersonToNotes.changeset(ptn)
    #                 |> Repo.delete
    #               end)
  end



############################ TESTING ############################

@testing_values [
                  %{name: "will"},
                  %{name: "bilbo"},
                  %{text: "boxer"},
                  %{text: "walking"}
                ]



  def setup do
    [person, person2, note, note2] = @testing_values
    create_person(person)
    read_person(person)
    |> IO.inspect(label: "person")

    create_person(person2)
    update_person(person2, Map.put(person2, :phone, "7777777777"))
    |> IO.inspect(label: "person 2")

    create_note(note)
    read_note(note)
    |> IO.inspect(label: "note")

    bad_note = %{text: "walking!"}
    create_note(bad_note)
    update_note(bad_note, note2)
    |> IO.inspect(label: "note 2")

    :done
  end

  def working do
    [person, person2, note, note2] = @testing_values

    create_person_notes(person,  note)
    create_person_notes(person,  note2)
    update_person_notes(person2, note)
    update_person_notes(person2, note2)

    read_person_notes(%{person: person})
    |> IO.inspect(label: "#{person.name} person notes")

    read_person_notes(%{notes: note})
    |> IO.inspect(label: "#{note.text} person notes")
  end

  def teardown do
    [person, person2, note, note2] = @testing_values
    delete_person(person2)
    delete_person(person)
    delete_note(note2)
    delete_note(note)

    :done
  end

  def tester do
    setup()
    working()
    teardown()
  end
end
