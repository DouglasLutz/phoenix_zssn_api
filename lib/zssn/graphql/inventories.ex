defmodule Zssn.Graphql.Inventories do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Zssn.Repo
  alias Zssn.Inventories.SurvivorItem

  def list_survivor_items(_) do
    Repo.all(SurvivorItem)
  end

  @spec get_survivor_item_by(%{item_id: integer() | binary(), survivor_id: integer() | binary()}) :: Zssn.Inventories.SurvivorItem.t() | nil
  def get_survivor_item_by(%{survivor_id: survivor_id, item_id: item_id}) do
    Repo.get_by(SurvivorItem, %{survivor_id: survivor_id, item_id: item_id})
  end

  @spec get_or_create_survivor_item(%{item_id: integer() | binary(), survivor_id: integer() | binary()}) :: Zssn.Inventories.SurvivorItem.t()
  def get_or_create_survivor_item(%{survivor_id: survivor_id, item_id: item_id}) do
      case get_survivor_item_by(%{survivor_id: survivor_id, item_id: item_id}) do
        %SurvivorItem{} = survivor_item ->
          survivor_item
        nil ->
          {:ok, %SurvivorItem{} = survivor_item} = create_survivor_item(%{survivor_id: survivor_id, item_id: item_id, quantity: 0})
          survivor_item
      end
  end

  @spec create_survivor_item(%{optional(atom | binary) => binary | number()}) :: {:ok, Zssn.Inventories.SurvivorItem.t()} | {:error, Ecto.Changeset}
  def create_survivor_item(attrs \\ %{}) do
    %SurvivorItem{}
    |> SurvivorItem.changeset(attrs)
    |> Repo.insert()
  end

  @spec change_survivor_item(
          Zssn.Inventories.SurvivorItem.t(),
          %{optional(atom | binary) => binary | number()}
        ) :: Ecto.Changeset.t()
  def change_survivor_item(%SurvivorItem{} = survivor_item, attrs \\ %{}) do
    SurvivorItem.changeset(survivor_item, attrs)
  end

  @spec trade_items(%{first_trade_items: any, second_trade_items: any}) :: {:ok, binary} | {:error, binary}
  def trade_items(%{first_trade_items: _, second_trade_items: _} = trade_items) do
    with(
      :ok <- validate_survivor_inventories(trade_items),
      :ok <- validate_trade_items(trade_items),
      :ok <- validate_trade_values(trade_items),
      :ok <- trade(trade_items)
    ) do
      {:ok, "Trade completed"}
    else
      {:error, message} ->
        {:error, message}
      _ ->
        {:error, "Couldn't complete the trade"}
    end
  end

  defp trade(attrs) do
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

  defp change_trade_suvivor_items(%{first_trade_items: first_trade_items, second_trade_items: second_trade_items}) do
    other_survivor_id = List.first(second_trade_items).survivor_id

    changesets =
    Enum.reduce(first_trade_items, [], fn %{item_id: item_id, quantity: quantity, survivor_id: survivor_id}, list ->
      remove_from = get_survivor_item_by(%{item_id: item_id, survivor_id: survivor_id})
      insert_into = get_or_create_survivor_item(%{item_id: item_id, survivor_id: other_survivor_id})

      list ++
      [
        change_survivor_item(remove_from, %{quantity: remove_from.quantity - quantity}),
        change_survivor_item(insert_into, %{quantity: insert_into.quantity + quantity})
      ]
    end)

    other_survivor_id = List.first(first_trade_items).survivor_id

    changesets = changesets ++
      Enum.reduce(second_trade_items, [], fn %{item_id: item_id, quantity: quantity, survivor_id: survivor_id}, list ->
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

  defp validate_survivor_inventories(%{first_trade_items: first_trade_items, second_trade_items: second_trade_items}) do
    with(
      :ok <- validate_survivor_inventory(first_trade_items),
      :ok <- validate_survivor_inventory(second_trade_items)
    ) do
      :ok
    else
      :error ->
        {:error, "Invalid trade items"}
    end
  end

  defp validate_survivor_inventory(trade_items) do
    valid? =
      trade_items
      |> Enum.map(fn %{item_id: item_id, quantity: quantity, survivor_id: survivor_id} ->
        inventory_quantity =
          case get_survivor_item_by(%{item_id: item_id, survivor_id: survivor_id}) do
            %SurvivorItem{} = survivor_item ->
              survivor_item.quantity
            nil ->
              0
          end

        %{
          trade_quantity: quantity,
          inventory_quantity: inventory_quantity
        }
      end)
      |> Enum.reduce(true, fn value, acc -> acc && (value.inventory_quantity >= value.trade_quantity) end)

    if valid? do
      :ok
    else
      :error
    end
  end

  defp validate_trade_items(%{first_trade_items: first_trade_items, second_trade_items: second_trade_items}) do
    {list_1, list_2} =
      { Enum.map(first_trade_items, fn %{item_id: item_id} -> item_id end),
        Enum.map(second_trade_items, fn %{item_id: item_id} -> item_id end)}

    unless Enum.any?(list_1, fn value -> value in list_2 end) do
      :ok
    else
      {:error, "Repeated items in the trade"}
    end
  end

  defp validate_trade_values(%{first_trade_items: first_trade_items, second_trade_items: second_trade_items}) do
    if sum_trade_values(first_trade_items) == sum_trade_values(second_trade_items) do
      :ok
    else
      {:error, "Trade values are not the same"}
    end
  end

  defp sum_trade_values(trade_items) do
    trade_items
    |> Enum.map(fn %{item_id: item_id, quantity: quantity} ->
      item = Zssn.Items.get_item!(item_id)
      quantity * item.value
    end)
    |> Enum.sum
  end

end
