defmodule ZssnWeb.Schema.Query.InventoriesTest do
  use ZssnWeb.ConnCase

  setup do
    Zssn.Seeds.survivor_with_inventory()

    {:ok, conn: build_conn()}
  end

  @query """
  {
    survivor_items {
      quantity
    }
  }
  """
  test "survivor_items field returns survivor_items", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivor_items" => [%{"quantity" => 42}]
      }
    }
  end
end
