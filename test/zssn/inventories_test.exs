defmodule Zssn.InventoriesTest do
  use Zssn.DataCase

  alias Zssn.Inventories
  alias Zssn.Inventories.SurvivorItem

  def survivor_with_item_fixture() do
    survivor = Zssn.Seeds.survivor_with_inventory()
    survivor_item = List.first(survivor.survivor_items)

    {survivor, survivor_item}
  end

  test "get_survivor_item!/1 returns the survivor_item with given id" do
    {_, survivor_item} = survivor_with_item_fixture()
    assert Inventories.get_survivor_item!(survivor_item.id) == survivor_item
  end

  test "create_survivor_item/1 with valid data creates a survivor_item" do
    survivor = Zssn.Seeds.survivors() |> List.first()
    item = Zssn.Seeds.items() |> List.first()

    assert {:ok, %SurvivorItem{} = survivor_item} = Inventories.create_survivor_item(%{survivor_id: survivor.id, item_id: item.id, quantity: 42})
    assert survivor_item.quantity == 42
  end

  test "create_survivor_item/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Inventories.create_survivor_item(%{survivor_id: 40, item_id: 67, quantity: 42})
  end

  test "update_survivor_item/2 with valid data updates the survivor_item" do
    {_, survivor_item} = survivor_with_item_fixture()

    assert {:ok, %SurvivorItem{} = survivor_item} = Inventories.update_survivor_item(survivor_item, %{quantity: 43})
    assert survivor_item.quantity == 43
  end

  test "change_survivor_item/1 returns a survivor_item changeset" do
    {_, survivor_item} = survivor_with_item_fixture()
    assert %Ecto.Changeset{} = Inventories.change_survivor_item(survivor_item)
  end

  test "get_survivor_item_by/1 with valid data returns the a survivor_item" do
    {survivor, survivor_item} = survivor_with_item_fixture()

    assert survivor_item == Inventories.get_survivor_item_by(%{item_id: survivor_item.item_id, survivor_id: survivor.id})
  end

  test "get_or_create_survivor_item/1 with valid data returns the correct survivor_item" do
    survivor = Zssn.Seeds.survivors() |> List.first()
    item = Zssn.Seeds.items() |> List.first()

    assert %SurvivorItem{} = created_survivor_item = Inventories.get_or_create_survivor_item(%{survivor_id: survivor.id, item_id: item.id})
    assert %SurvivorItem{} = gotten_survivor_item = Inventories.get_or_create_survivor_item(%{survivor_id: survivor.id, item_id: item.id})
    assert created_survivor_item.id == gotten_survivor_item.id
  end

  test "trade_items/1 with valid data returns :ok" do
    {_, first_survivor_item} = survivor_with_item_fixture()
    {_, second_survivor_item} = survivor_with_item_fixture()

    trade_params = %{
      "trade_items_1" => [%{
        "survivor_id" => first_survivor_item.survivor_id,
        "item_id" => first_survivor_item.item_id,
        "quantity" => first_survivor_item.quantity - 10
      }],
      "trade_items_2" => [%{
        "survivor_id" => second_survivor_item.survivor_id,
        "item_id" => second_survivor_item.item_id,
        "quantity" => second_survivor_item.quantity - 10
      }]
    }

    assert :ok = Inventories.trade_items(trade_params)
  end
end
