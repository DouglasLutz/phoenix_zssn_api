defmodule Zssn.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Zssn.Repo

  alias Zssn.Resources.Item

  def list_items do
    Repo.all(Item)
  end

  def get_item!(id), do: Repo.get!(Item, id)

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  alias Zssn.Resources.Survivor

  def list_survivors do
    Repo.all(Survivor)
    |> Repo.preload(:survivor_items)
  end

  def get_survivor!(id) do
    Survivor
    |> Repo.get!(id)
    |> Repo.preload(:survivor_items)
  end

  def create_survivor(attrs \\ %{}) do
    %Survivor{}
    |> Survivor.changeset(attrs)
    |> Repo.insert()
  end

  def update_survivor(%Survivor{} = survivor, attrs) do
    survivor
    |> Survivor.changeset(attrs)
    |> Repo.update()
  end

  def change_survivor(%Survivor{} = survivor, attrs \\ %{}) do
    Survivor.changeset(survivor, attrs)
  end

  alias Zssn.Resources.SurvivorItem

  def get_survivor_item!(id) do
    Repo.get!(SurvivorItem, id)
  end

  def get_survivor_item_by(attrs) do
    Repo.get_by(SurvivorItem, %{survivor_id: attrs.survivor_id, item_id: attrs.item_id})
  end

  def update_or_create_survivor_item(attrs) do
      case get_survivor_item_by(attrs) do
        %SurvivorItem{} = survivor_item ->
          update_survivor_item(survivor_item, attrs)
        nil ->
          create_survivor_item(attrs)
      end
  end

  def create_survivor_item(attrs \\ %{}) do
    %SurvivorItem{}
    |> SurvivorItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_survivor_item(%SurvivorItem{} = survivor_item, attrs) do
    survivor_item
    |> SurvivorItem.changeset(attrs)
    |> Repo.update()
  end

  def change_survivor_item(%SurvivorItem{} = survivor_item, attrs \\ %{}) do
    SurvivorItem.changeset(survivor_item, attrs)
  end
end
