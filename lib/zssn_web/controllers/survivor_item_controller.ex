defmodule ZssnWeb.SurvivorItemController do
  use ZssnWeb, :controller

  alias Zssn.Inventories
  alias Zssn.Inventories.SurvivorItem

  action_fallback ZssnWeb.FallbackController

  def trade(conn, trade_items) do
    with(
      :ok <- validate_survivor_inventories(trade_items),
      :ok <- validate_trade_items(trade_items),
      :ok <- validate_trade_values(trade_items),
      :ok <- Inventories.trade_items(trade_items)
    ) do
      send_resp(conn, :no_content, "")
    else
      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", %{message: message})
      _ ->
        conn
        |> put_status(:internal_server_error)
        |> render("error.json")
    end
  end

  defp validate_survivor_inventories(%{"trade_items_1" => trade_items_1, "trade_items_2" => trade_items_2}) do
    with(
      :ok <- validate_survivor_inventory(trade_items_1),
      :ok <- validate_survivor_inventory(trade_items_2)
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
      |> Enum.map(fn survivor_item_attrs ->
        inventory_quantity =
          case Inventories.get_survivor_item_by(%{item_id: survivor_item_attrs["item_id"], survivor_id: survivor_item_attrs["survivor_id"]}) do
            %SurvivorItem{} = survivor_item ->
              survivor_item.quantity
            nil ->
              0
          end

        %{
          trade_quantity: survivor_item_attrs["quantity"],
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

  defp validate_trade_items(%{"trade_items_1" => trade_items_1, "trade_items_2" => trade_items_2}) do
    {list_1, list_2} = {Enum.map(trade_items_1, fn survivor_item_attrs -> survivor_item_attrs["item_id"] end), Enum.map(trade_items_2, fn survivor_item_attrs -> survivor_item_attrs["item_id"] end)}

    unless Enum.any?(list_1, fn value -> value in list_2 end) do
      :ok
    else
      {:error, "Repeated items in the trade"}
    end
  end

  defp validate_trade_values(%{"trade_items_1" => trade_items_1, "trade_items_2" => trade_items_2}) do
    if sum_trade_values(trade_items_1) == sum_trade_values(trade_items_2) do
      :ok
    else
      {:error, "Trade values are not the same"}
    end
  end

  defp sum_trade_values(trade_items) do
    trade_items
    |> Enum.map(fn survivor_item_attrs ->
      item = Zssn.Items.get_item!(survivor_item_attrs["item_id"])
      survivor_item_attrs["quantity"] * item.value
    end)
    |> Enum.sum
  end



end
