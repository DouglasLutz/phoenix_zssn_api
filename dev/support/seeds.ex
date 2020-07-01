defmodule Zssn.Seeds do
  alias Zssn.Repo
  alias Zssn.Resources.{Item, Survivor}

  def run() do
    Repo.insert! %Item{name: "Water", value: 4}
    Repo.insert! %Item{name: "Food", value: 3}
    Repo.insert! %Item{name: "Medication", value: 2}
    Repo.insert! %Item{name: "Ammunition", value: 1}

    Repo.insert! %Survivor{
      name: "Douglas",
      age: 22,
      gender: "male",
      infected: false,
      latitude: 22.392833,
      longitude: 22.392833,
      reports: 0
    }

    Repo.insert! %Survivor{
      name: "Peter",
      age: 25,
      gender: "male",
      infected: false,
      latitude: 30.392833,
      longitude: 42.392833,
      reports: 0
    }
  end
end
