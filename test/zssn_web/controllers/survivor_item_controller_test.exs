defmodule ZssnWeb.SurvivorItemControllerTest do
  use ZssnWeb.ConnCase

  alias Zssn.{Items, Survivors, Inventories}

  @valid_item_attrs %{name: "some name", value: 42}
  @valid_survivor_attrs %{age: 42, gender: "some gender", latitude: "120.5", longitude: "120.5", name: "some name"}

  def fixture(:survivor_items) do
    {:ok, item_1} = Items.create_item(@valid_item_attrs)
    {:ok, item_2} = Items.create_item(@valid_item_attrs)

    {:ok, survivor} =
      @valid_survivor_attrs
      |> Enum.into(%{survivor_items: [%{item_id: item_1.id, quantity: 42}, %{item_id: item_2.id, quantity: 42}]})
      |> Survivors.create_survivor()

    survivor = Survivors.get_survivor(survivor.id)
    first_survivor_item = survivor.survivor_items |> Enum.at(0)

    {:ok, survivor} =
      @valid_survivor_attrs
      |> Enum.into(%{survivor_items: [%{item_id: item_2.id, quantity: 42}, %{item_id: item_1.id, quantity: 42}]})
      |> Survivors.create_survivor()

    survivor = Survivors.get_survivor(survivor.id)
    second_survivor_item = survivor.survivor_items |> Enum.at(0)

    {first_survivor_item, second_survivor_item}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "trade" do
    setup [:create_survivor_items]

    test "returns status code :no_content when trade is processed", %{conn: conn, first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item} do
      trade_params = %{
        "trade_items_1" => [%{
          "survivor_id" =>  first_survivor_item.survivor_id,
          "item_id" =>      first_survivor_item.item_id,
          "quantity" =>     first_survivor_item.quantity - 10
        }],
        "trade_items_2" => [%{
          "survivor_id" =>  second_survivor_item.survivor_id,
          "item_id" =>      second_survivor_item.item_id,
          "quantity" =>     second_survivor_item.quantity - 10
        }]
      }

      conn = put(conn, Routes.survivor_item_path(conn, :trade), trade_params)
      assert response(conn, 204) == ""
    end

    test "returns error message when survivor_item quantity is lower than the trade", %{conn: conn, first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item} do
      trade_params = %{
        "trade_items_1" => [%{
          "survivor_id" =>  first_survivor_item.survivor_id,
          "item_id" =>      first_survivor_item.item_id,
          "quantity" =>     first_survivor_item.quantity + 10
        }],
        "trade_items_2" => [%{
          "survivor_id" =>  second_survivor_item.survivor_id,
          "item_id" =>      second_survivor_item.item_id,
          "quantity" =>     second_survivor_item.quantity + 10
        }]
      }

      conn = put(conn, Routes.survivor_item_path(conn, :trade), trade_params)
      assert json_response(conn, :unprocessable_entity)["message"] == "Invalid trade items"
    end

    test "returns error message when survivor_item is repeated in the trade", %{conn: conn, first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item} do
      trade_params = %{
        "trade_items_1" => [%{
          "survivor_id" =>  first_survivor_item.survivor_id,
          "item_id" =>      first_survivor_item.item_id,
          "quantity" =>     first_survivor_item.quantity
        }],
        "trade_items_2" => [%{
          "survivor_id" =>  second_survivor_item.survivor_id,
          "item_id" =>      first_survivor_item.item_id,
          "quantity" =>     second_survivor_item.quantity
        }]
      }

      conn = put(conn, Routes.survivor_item_path(conn, :trade), trade_params)
      assert json_response(conn, :unprocessable_entity)["message"] == "Repeated items in the trade"
    end

    test "returns error message when trade values are not the same", %{conn: conn, first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item} do
      trade_params = %{
        "trade_items_1" => [%{
          "survivor_id" =>  first_survivor_item.survivor_id,
          "item_id" =>      first_survivor_item.item_id,
          "quantity" =>     1
        }],
        "trade_items_2" => [%{
          "survivor_id" =>  second_survivor_item.survivor_id,
          "item_id" =>      second_survivor_item.item_id,
          "quantity" =>     2
        }]
      }

      conn = put(conn, Routes.survivor_item_path(conn, :trade), trade_params)
      assert json_response(conn, :unprocessable_entity)["message"] == "Trade values are not the same"
    end
  end


  defp create_survivor_items(_) do
    {first_survivor_item, second_survivor_item} = fixture(:survivor_items)
    %{first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item}
  end
end
