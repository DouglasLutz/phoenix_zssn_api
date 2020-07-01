defmodule Zssn.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Zssn.Repo
  alias Zssn.Resources.Item

  @spec list_items() :: [%Item{}]
  def list_items do
    Repo.all(Item)
  end

  @spec get_item!(integer() | binary()) :: %Item{}
  def get_item!(id), do: Repo.get!(Item, id)

  @spec create_item(%{optional(atom | binary) => binary | number()}) :: {:ok, %Item{}} | {:error, Ecto.Changeset}
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_item(%Item{}, %{optional(atom | binary) => binary | number()}) :: {:ok, %Item{}} | {:error, Ecto.Changeset}
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  alias Zssn.Resources.Survivor

  @spec list_survivors() :: [%Survivor{}]
  def list_survivors do
    Repo.all(Survivor)
    |> Repo.preload(:survivor_items)
  end

  @spec get_survivor!(integer() | binary()) :: %Survivor{}
  def get_survivor!(id) do
    Survivor
    |> Repo.get!(id)
    |> Repo.preload(:survivor_items)
  end

  @spec get_survivor(integer() | binary()) :: %Survivor{} | nil
  def get_survivor(id) do
    Survivor
    |> Repo.get(id)
    |> Repo.preload(:survivor_items)
  end

  @spec create_survivor(%{optional(atom | binary) => binary | number()}) :: {:ok, %Survivor{}} | {:error, Ecto.Changeset}
  def create_survivor(attrs \\ %{}) do
    %Survivor{}
    |> Survivor.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_survivor(%Survivor{}, %{optional(atom | binary) => binary | number()}) :: {:ok, %Survivor{}} | {:error, Ecto.Changeset}
  def update_survivor(%Survivor{} = survivor, attrs) do
    survivor
    |> Survivor.changeset(attrs)
    |> Repo.update()
  end

  alias Zssn.Resources.SurvivorItem

  @spec get_survivor_item!(integer() | binary()) :: Zssn.Resources.SurvivorItem.t()
  def get_survivor_item!(id) do
    Repo.get!(SurvivorItem, id)
  end

  @spec get_survivor_item_by(%{item_id: integer() | binary(), survivor_id: integer() | binary()}) :: Zssn.Resources.SurvivorItem.t() | nil
  def get_survivor_item_by(%{survivor_id: survivor_id, item_id: item_id}) do
    Repo.get_by(SurvivorItem, %{survivor_id: survivor_id, item_id: item_id})
  end

  @spec get_or_create_survivor_item(%{item_id: integer() | binary(), survivor_id: integer() | binary()}) :: Zssn.Resources.SurvivorItem.t()
  def get_or_create_survivor_item(%{survivor_id: survivor_id, item_id: item_id}) do
      case get_survivor_item_by(%{survivor_id: survivor_id, item_id: item_id}) do
        %SurvivorItem{} = survivor_item ->
          survivor_item
        nil ->
          {:ok, %SurvivorItem{} = survivor_item} = create_survivor_item(%{survivor_id: survivor_id, item_id: item_id, quantity: 0})
          survivor_item
      end
  end

  @spec create_survivor_item(%{optional(atom | binary) => binary | number()}) :: {:ok, Zssn.Resources.SurvivorItem.t()} | {:error, Ecto.Changeset}
  def create_survivor_item(attrs \\ %{}) do
    %SurvivorItem{}
    |> SurvivorItem.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_survivor_item(
          Zssn.Resources.SurvivorItem.t(),
          %{optional(atom | binary) => binary | number()}
        ) :: {:ok, Zssn.Resources.SurvivorItem.t()} | {:error, Ecto.Changeset.t()}
  def update_survivor_item(%SurvivorItem{} = survivor_item, attrs) do
    survivor_item
    |> SurvivorItem.changeset(attrs)
    |> Repo.update()
  end

  @spec change_survivor_item(
          Zssn.Resources.SurvivorItem.t(),
          %{optional(atom | binary) => binary | number()}
        ) :: Ecto.Changeset.t()
  def change_survivor_item(%SurvivorItem{} = survivor_item, attrs \\ %{}) do
    SurvivorItem.changeset(survivor_item, attrs)
  end

  @spec trade_items(%{required(binary) => [], required(binary) => []}) :: :ok | {:error, any}
  def trade_items(%{"trade_items_1" => _, "trade_items_2" => _} = attrs) do
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

  @spec change_trade_suvivor_items(%{required(binary) => [], required(binary) => []}) :: [Ecto.Changeset.t()]
  defp change_trade_suvivor_items(%{"trade_items_1" => trade_items_1, "trade_items_2" => trade_items_2}) do
    other_survivor_id = List.first(trade_items_2) |> Map.get("survivor_id")

    changesets =
    Enum.reduce(trade_items_1, [], fn %{"item_id" => item_id, "quantity" => quantity, "survivor_id" => survivor_id}, list ->
      remove_from = get_survivor_item_by(%{item_id: item_id, survivor_id: survivor_id})
      insert_into = get_or_create_survivor_item(%{item_id: item_id, survivor_id: other_survivor_id})

      list ++
      [
        change_survivor_item(remove_from, %{quantity: remove_from.quantity - quantity}),
        change_survivor_item(insert_into, %{quantity: insert_into.quantity + quantity})
      ]
    end)

    other_survivor_id = List.first(trade_items_1) |> Map.get("survivor_id")

    changesets = changesets ++
      Enum.reduce(trade_items_2, [], fn %{"item_id" => item_id, "quantity" => quantity, "survivor_id" => survivor_id}, list ->
        remove_from = get_survivor_item_by(%{item_id: item_id, survivor_id: survivor_id})
        insert_into = get_or_create_survivor_item(%{item_id: item_id, survivor_id: other_survivor_id})

        list ++
          [
            change_survivor_item(remove_from, %{quantity: remove_from.quantity - quantity}),
            change_survivor_item(insert_into, %{quantity: insert_into.quantity + quantity})
          ]
      end)

    changesets
  end
end
