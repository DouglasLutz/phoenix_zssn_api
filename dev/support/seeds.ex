defmodule Zssn.Seeds do
  alias Zssn.Repo
  alias Zssn.Items.Item
  alias Zssn.Survivors.Survivor

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

  def items() do
    items = [%Item{name: "Water", value: 4}, %Item{name: "Food", value: 3}, %Item{name: "Medication", value: 2}, %Item{name: "Ammunition", value: 1}]

    Enum.map(items, fn item ->
      Repo.insert! item
    end)
  end

  def survivors() do
    survivors_attrs = [
      %{
        name: "Douglas",
        age: 22,
        gender: "male",
        infected: false,
        latitude: 22.392833,
        longitude: 22.392833,
        reports: 0
      },
      %{
        name: "Peter",
        age: 25,
        gender: "male",
        infected: false,
        latitude: 30.392833,
        longitude: 42.392833,
        reports: 0
      }
    ]

    Enum.map(survivors_attrs, fn survivor ->
      {:ok, created_survivor} = Zssn.Survivors.create_survivor(survivor)
      Zssn.Survivors.get_survivor(created_survivor.id)
    end)
  end

  def survivor_with_inventory() do
    item = Repo.insert! %Item{name: "Water", value: 4}

    {:ok, survivor} =
      Zssn.Survivors.create_survivor(%{
        name: "Douglas",
        age: 22,
        gender: "male",
        infected: false,
        latitude: 22.392833,
        longitude: 22.392833,
        reports: 0,
        survivor_items: [%{item_id: item.id, quantity: 42}]
      })

    Zssn.Survivors.get_survivor(survivor.id)
  end
end
