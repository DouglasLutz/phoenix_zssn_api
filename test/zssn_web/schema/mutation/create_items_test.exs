defmodule ZssnWeb.Schema.Mutation.CreateItemsTest do
  use ZssnWeb.ConnCase, async: true

  setup do
    {:ok, conn: build_conn()}
  end


  @query """
  mutation CreateItem($item: ItemCreateInput!) {
    createItem(input: $item) {
      errors {
        key
        message
      }
      item {
        name
        value
      }
    }
  }
  """
  @item %{
    name: "AK-47",
    value: 20
  }
  test "createItem field creates a item", %{conn: conn} do
    conn = post conn, "/api", query: @query, variables: %{"item" => @item}

    assert json_response(conn, 200) == %{
      "data" => %{
        "createItem" => %{
          "errors" => nil,
          "item" => %{
            "name" => @item.name,
            "value" => @item.value
          }
        }
      }
    }
  end

  @item %{
    name: "AK-47"
  }
  test "creating a item without a value fails", %{conn: conn} do
    conn = post conn, "/api", query: @query, variables: %{"item" => @item}

    assert json_response(conn, 200) == %{
      "data" => %{
        "createItem" => %{
          "errors" => [
            %{"key" => "value", "message" => "can't be blank"}
          ],
          "item" => nil
        }
      }
    }
  end
end
