defmodule Zssn.SurvivorsTest do
  use Zssn.DataCase

  alias Zssn.Survivors
  alias Zssn.Survivors.Survivor

  def survivor_fixture() do
    survivors = Zssn.Seeds.survivors()
    {survivors, List.first(survivors)}
  end

  test "list_survivors/0 returns all survivors" do
    {survivors, _} = survivor_fixture()
    assert Survivors.list_survivors() == survivors
  end

  test "get_survivor!/1 returns the survivor with given id" do
    {_, survivor} = survivor_fixture()
    assert Survivors.get_survivor!(survivor.id) == survivor
  end

  @valid_attrs %{age: 42, gender: "some gender", latitude: "120.5", longitude: "120.5", name: "some name"}
  test "create_survivor/1 with valid data creates a survivor" do
    assert {:ok, %Survivor{} = survivor} = Survivors.create_survivor(@valid_attrs)
    assert survivor.age == 42
    assert survivor.gender == "some gender"
    assert survivor.latitude == Decimal.new("120.5")
    assert survivor.longitude == Decimal.new("120.5")
    assert survivor.name == "some name"
  end

  @invalid_attrs %{age: nil, gender: nil, latitude: nil, longitude: nil, name: nil}
  test "create_survivor/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Survivors.create_survivor(@invalid_attrs)
  end

  @update_attrs %{age: 43, gender: "some updated gender", latitude: "456.7", longitude: "456.7", name: "some updated name"}
  test "update_survivor/2 with valid data updates the survivor" do
    {_, survivor} = survivor_fixture()
    assert {:ok, %Survivor{} = survivor} = Survivors.update_survivor(survivor, @update_attrs)
    assert survivor.age == 43
    assert survivor.gender == "some updated gender"
    assert survivor.latitude == Decimal.new("456.7")
    assert survivor.longitude == Decimal.new("456.7")
    assert survivor.name == "some updated name"
  end

  @invalid_attrs %{age: nil, gender: nil, latitude: nil, longitude: nil, name: nil}
  test "update_survivor/2 with invalid data returns error changeset" do
    {_, survivor} = survivor_fixture()
    assert {:error, %Ecto.Changeset{}} = Survivors.update_survivor(survivor, @invalid_attrs)
    assert survivor == Survivors.get_survivor!(survivor.id)
  end
end
