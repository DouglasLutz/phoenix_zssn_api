defmodule ZssnWeb.Schema.Mutation.TradeItemsTest do
  use ZssnWeb.ConnCase, async: true

  setup do
    first_survivor = Zssn.Seeds.survivor_with_inventory()
    second_survivor = Zssn.Seeds.survivor_with_inventory()

    {:ok, conn: build_conn(), first_survivor_item: List.first(first_survivor.survivor_items), second_survivor_item: List.first(second_survivor.survivor_items)}
  end

  @query """
  mutation TradeItems($input: TradeInput!) {
    tradeItems(input: $input) {
      message
    }
  }
  """
  test "tradeItems field proccesses the trade", %{conn: conn, first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item} do
    trade_params = %{
      "first_trade_items" => [%{
        "survivor_id" =>  first_survivor_item.survivor_id,
        "item_id" =>      first_survivor_item.item_id,
        "quantity" =>     first_survivor_item.quantity - 10
      }],
      "second_trade_items" => [%{
        "survivor_id" =>  second_survivor_item.survivor_id,
        "item_id" =>      second_survivor_item.item_id,
        "quantity" =>     second_survivor_item.quantity - 10
      }]
    }

    conn = post conn, "/api", query: @query, variables: %{"input" => trade_params}

    assert json_response(conn, 200) == %{
      "data" => %{
        "tradeItems" => %{
          "message" => "Trade completed"
        }
      }
    }
  end

  test "tradeItems field with different values between inventories returns error message", %{conn: conn, first_survivor_item: first_survivor_item, second_survivor_item: second_survivor_item} do
    trade_params = %{
      "first_trade_items" => [%{
        "survivor_id" =>  first_survivor_item.survivor_id,
        "item_id" =>      first_survivor_item.item_id,
        "quantity" =>     first_survivor_item.quantity - 10
      }],
      "second_trade_items" => [%{
        "survivor_id" =>  second_survivor_item.survivor_id,
        "item_id" =>      second_survivor_item.item_id,
        "quantity" =>     second_survivor_item.quantity - 5
      }]
    }

    conn = post conn, "/api", query: @query, variables: %{"input" => trade_params}

    assert %{
      "errors" => [%{
        "message" => message}]
    } = json_response(conn, 200)

    assert message == "Trade values are not the same"
  end

end
