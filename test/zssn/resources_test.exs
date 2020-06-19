defmodule Zssn.ResourcesTest do
  use Zssn.DataCase

  alias Zssn.Resources

  describe "items" do
    alias Zssn.Resources.Item

    @valid_attrs %{name: "some name", value: 42}
    @update_attrs %{name: "some updated name", value: 43}
    @invalid_attrs %{name: nil, value: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Resources.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Resources.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Resources.create_item(@valid_attrs)
      assert item.name == "some name"
      assert item.value == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Resources.update_item(item, @update_attrs)
      assert item.name == "some updated name"
      assert item.value == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_item(item, @invalid_attrs)
      assert item == Resources.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Resources.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Resources.change_item(item)
    end
  end

  describe "survivors" do
    alias Zssn.Resources.Survivor

    @valid_attrs %{age: 42, gender: "some gender", latitude: "120.5", longitude: "120.5", name: "some name"}
    @update_attrs %{age: 43, gender: "some updated gender", latitude: "456.7", longitude: "456.7", name: "some updated name"}
    @invalid_attrs %{age: nil, gender: nil, latitude: nil, longitude: nil, name: nil}

    def survivor_fixture(attrs \\ %{}) do
      {:ok, survivor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_survivor()

      survivor
    end

    test "list_survivors/0 returns all survivors" do
      survivor = survivor_fixture()
      assert Resources.list_survivors() == [survivor]
    end

    test "get_survivor!/1 returns the survivor with given id" do
      survivor = survivor_fixture()
      assert Resources.get_survivor!(survivor.id) == survivor
    end

    test "create_survivor/1 with valid data creates a survivor" do
      assert {:ok, %Survivor{} = survivor} = Resources.create_survivor(@valid_attrs)
      assert survivor.age == 42
      assert survivor.gender == "some gender"
      assert survivor.latitude == Decimal.new("120.5")
      assert survivor.longitude == Decimal.new("120.5")
      assert survivor.name == "some name"
    end

    test "create_survivor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_survivor(@invalid_attrs)
    end

    test "update_survivor/2 with valid data updates the survivor" do
      survivor = survivor_fixture()
      assert {:ok, %Survivor{} = survivor} = Resources.update_survivor(survivor, @update_attrs)
      assert survivor.age == 43
      assert survivor.gender == "some updated gender"
      assert survivor.latitude == Decimal.new("456.7")
      assert survivor.longitude == Decimal.new("456.7")
      assert survivor.name == "some updated name"
    end

    test "update_survivor/2 with invalid data returns error changeset" do
      survivor = survivor_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_survivor(survivor, @invalid_attrs)
      assert survivor == Resources.get_survivor!(survivor.id)
    end

    test "delete_survivor/1 deletes the survivor" do
      survivor = survivor_fixture()
      assert {:ok, %Survivor{}} = Resources.delete_survivor(survivor)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_survivor!(survivor.id) end
    end

    test "change_survivor/1 returns a survivor changeset" do
      survivor = survivor_fixture()
      assert %Ecto.Changeset{} = Resources.change_survivor(survivor)
    end
  end

  describe "survivor_items" do
    alias Zssn.Resources.SurvivorItem

    @valid_attrs %{quantity: 42}
    @update_attrs %{quantity: 43}
    @invalid_attrs %{quantity: nil}

    def survivor_item_fixture(attrs \\ %{}) do
      {:ok, survivor_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_survivor_item()

      survivor_item
    end

    test "list_survivor_items/0 returns all survivor_items" do
      survivor_item = survivor_item_fixture()
      assert Resources.list_survivor_items() == [survivor_item]
    end

    test "get_survivor_item!/1 returns the survivor_item with given id" do
      survivor_item = survivor_item_fixture()
      assert Resources.get_survivor_item!(survivor_item.id) == survivor_item
    end

    test "create_survivor_item/1 with valid data creates a survivor_item" do
      assert {:ok, %SurvivorItem{} = survivor_item} = Resources.create_survivor_item(@valid_attrs)
      assert survivor_item.quantity == 42
    end

    test "create_survivor_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_survivor_item(@invalid_attrs)
    end

    test "update_survivor_item/2 with valid data updates the survivor_item" do
      survivor_item = survivor_item_fixture()
      assert {:ok, %SurvivorItem{} = survivor_item} = Resources.update_survivor_item(survivor_item, @update_attrs)
      assert survivor_item.quantity == 43
    end

    test "update_survivor_item/2 with invalid data returns error changeset" do
      survivor_item = survivor_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_survivor_item(survivor_item, @invalid_attrs)
      assert survivor_item == Resources.get_survivor_item!(survivor_item.id)
    end

    test "delete_survivor_item/1 deletes the survivor_item" do
      survivor_item = survivor_item_fixture()
      assert {:ok, %SurvivorItem{}} = Resources.delete_survivor_item(survivor_item)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_survivor_item!(survivor_item.id) end
    end

    test "change_survivor_item/1 returns a survivor_item changeset" do
      survivor_item = survivor_item_fixture()
      assert %Ecto.Changeset{} = Resources.change_survivor_item(survivor_item)
    end
  end
end
