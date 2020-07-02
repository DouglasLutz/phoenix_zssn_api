defmodule Zssn.ItemsTest do
  use Zssn.DataCase

  alias Zssn.Items
  alias Zssn.Items.Item

  def item_fixture do
    items = Zssn.Seeds.items()
    {items, List.first(items)}
  end

  test "list_items/0 returns all items" do
    {items, _} = item_fixture()

    assert Items.list_items() == items
  end

  test "get_item!/1 returns the item with given id" do
    {_, item} = item_fixture()

    assert Items.get_item!(item.id) == item
  end

  @valid_attrs %{name: "some name", value: 42}
  test "create_item/1 with valid data creates a item" do
    assert {:ok, %Item{} = item} = Items.create_item(@valid_attrs)
    assert item.name == "some name"
    assert item.value == 42
  end

  @invalid_attrs %{name: nil, value: nil}
  test "create_item/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
  end

  @update_attrs %{name: "some updated name", value: 43}
  test "update_item/2 with valid data updates the item" do
    {_, item} = item_fixture()

    assert {:ok, %Item{} = item} = Items.update_item(item, @update_attrs)
    assert item.name == "some updated name"
    assert item.value == 43
  end

  @invalid_attrs %{name: nil}
  test "update_item/2 with invalid data returns error changeset" do
    {_, item} = item_fixture()

    assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
    assert item == Items.get_item!(item.id)
  end
end
