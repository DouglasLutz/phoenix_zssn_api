defmodule ZssnWeb.Schema.Query.ItemsTest do
  use ZssnWeb.ConnCase

  setup do
    Zssn.Seeds.run()

    {:ok, conn: build_conn()}
  end

  @query """
  {
    items {
      name
      value
    }
  }
  """
  test "items field returns items", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "items" => [
          %{
            "name" => "Ammunition",
            "value" => 1
          },
          %{
            "name" => "Food",
            "value" => 3
          },
          %{
            "name" => "Medication",
            "value" => 2
          },
          %{
            "name" => "Water",
            "value" => 4
          }
        ]
      }
    }
  end

  @query """
  {
    items(filter: {name: "water"}) {
      name
    }
  }
  """
  test "items field returns items filtered by name", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "items" => [%{"name" => "Water"}]
      }
    }
  end

  @query"""
  {
    items(order: DESC){
      name
    }
  }
  """
  test "items field returns items descending using literals", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert %{
      "data" => %{
        "items" => [%{"name" => "Water"}|_]
      }
    } = json_response(conn, 200)
  end

  @query """
  {
    items(filter: {name: 123}) {
      name
    }
  }
  """
  test "items field returns errors when using a bad value", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert %{
      "errors" => [
        %{"message" => message}
      ]
    } = json_response(conn, 200)
    assert message =~ "Argument \"filter\" has invalid value {name: 123}."
  end
end
