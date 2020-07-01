defmodule Zssn.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
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

  def get_survivor(id) do
    Survivor
    |> Repo.get(id)
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

  alias Zssn.Resources.SurvivorItem

  def get_survivor_item!(id) do
    Repo.get!(SurvivorItem, id)
  end

  def get_survivor_item_by(attrs) do
    Repo.get_by(SurvivorItem, %{survivor_id: attrs.survivor_id, item_id: attrs.item_id})
  end

  def get_or_create_survivor_item(attrs) do
      case get_survivor_item_by(attrs) do
        %SurvivorItem{} = survivor_item ->
          survivor_item
        nil ->
          {:ok, %SurvivorItem{} = survivor_item} = create_survivor_item(Map.merge(attrs, %{quantity: 0}))
          survivor_item
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

  def trade_items(attrs) do
    multi =
      change_trade_suvivor_items(attrs)
      |> Enum.reduce(Multi.new(), fn changeset, multi ->
        Multi.update(
          multi,
          {:survivor_item, changeset.data.id},
          changeset
        )
      end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        :ok
      {:error, _, failed_value, _} ->
        {:error, failed_value}
    end
  end

  defp change_trade_suvivor_items(attrs) do
    first_survivor_id = attrs["trade_items_1"] |> Enum.at(0) |> Map.get("survivor_id")
    second_survivor_id = attrs["trade_items_2"] |> Enum.at(0) |> Map.get("survivor_id")

    changesets =
      Enum.reduce(attrs["trade_items_1"], [], fn survivor_item_attrs, list ->
        remove_from = get_survivor_item_by(%{item_id: survivor_item_attrs["item_id"], survivor_id: first_survivor_id})
        insert_into = get_or_create_survivor_item(%{item_id: survivor_item_attrs["item_id"], survivor_id: second_survivor_id})

        list ++
          [
            change_survivor_item(remove_from, %{quantity: remove_from.quantity - survivor_item_attrs["quantity"]}),
            change_survivor_item(insert_into, %{quantity: insert_into.quantity + survivor_item_attrs["quantity"]})
          ]
      end)

      changesets = changesets ++
        Enum.reduce(attrs["trade_items_2"], [], fn survivor_item_attrs, list ->
          remove_from = get_survivor_item_by(%{item_id: survivor_item_attrs["item_id"], survivor_id: second_survivor_id})
          insert_into = get_or_create_survivor_item(%{item_id: survivor_item_attrs["item_id"], survivor_id: first_survivor_id})

          list ++
            [
              change_survivor_item(remove_from, %{quantity: remove_from.quantity - survivor_item_attrs["quantity"]}),
              change_survivor_item(insert_into, %{quantity: insert_into.quantity + survivor_item_attrs["quantity"]})
            ]
        end)

      changesets
  end
end
