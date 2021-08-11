defmodule NetworkingLog.Nodes do
  alias NetworkingLog.Nodes.Note
  alias NetworkingLog.Nodes.Person
  alias NetworkingLog.Nodes.PersonToNotes
  alias NetworkingLog.Repo

  import Ecto.Query

  def add(data) do
    Repo.insert(data)
  end
  def get_note(data = %{text: value}) when is_binary(value) do
    [record] = read_note(data)
    record
  end
  def get_person(data = %{name: value}) when is_binary(value) do
    [record] = read_person(data)
    record
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
      IO.write("data is invalid\n")
      IO.inspect(data, label: "data provided")
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
  def delete_person(data) when is_map(data) do
    if(!Map.has_key?(data, :name)) do
      IO.write("data is invalid\n")
      IO.inspect(data, label: "data provided")
    else
      [record | _tail] = read_person(data)
      Person.changeset(record, %{})
      |> preload(:notes)
      |> Repo.delete
    end
  end

  def create_note(data) when is_map(data) do
    if(!Map.has_key?(data, :text)) do
      IO.write("data is invalid\n")
      IO.inspect(data, label: "data provided")
    else
      %Note{}
      |> Note.changeset(data)
      |> Repo.insert
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
  def delete_note(data) when is_map(data) do
    if(!Map.has_key?(data, :text)) do
      IO.write("data is invalid\n")
      IO.inspect(data, label: "data provided")
    else
      get_note(data)
      |> Note.changeset(%{})
      |> Repo.delete
    end
  end

  def create_person_notes(person, note = %{text: text}) do
    people = read_person(person)
    notes = read_note(note)

    Note.changeset(note, people)
    |> Repo.update
    # # IO.inspect(people, label: "people from read")
    # [p_record] = people
    # p_record = Repo.preload(p_record, :notes)
    # # p_record.id
    # # p_record
    # # |> Repo.preload(:notes)
    # # |> Person.changeset(%{})
    # # |> Repo.update
    # [n_record] = notes
    # n_record = Repo.preload(n_record, :people)
    #
    # n_record = n_record
    # |> Repo.preload(:people)
    # |> Note.changeset(%{note_id: n_record.id, people: [people]})
    # |> Repo.update
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
  def update_person_notes(person, notes = %{text: text})  do

  end
  def delete_person_notes(person, notes = %{text: _text})  do
    read_person_notes(person, notes)
    |> Enum.each( fn(ptn) ->
                    PersonToNotes.changeset(ptn)
                    |> Repo.delete
                  end)
    # |> Repo.delete
  end



############################TESTING############################

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

    create_person_notes(person, note)
    # create_person_notes(person2, note2)
    # create_person_notes(person2, note)
    # create_person_notes(person, note2)

    # delete_person_notes(person2, note)

    # Repo.preload(n, :people)
    # |> Note.changeset(people)
    # |> Repo.update

    # IO.inspect(read_person_notes(person, note), label: "reading person notes 1")
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
