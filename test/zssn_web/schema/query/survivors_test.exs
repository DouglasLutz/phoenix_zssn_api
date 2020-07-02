defmodule ZssnWeb.Schema.Query.SurvivorsTest do
  use ZssnWeb.ConnCase

  setup do
    Zssn.Seeds.run()

    {:ok, conn: build_conn()}
  end

  @query """
  {
    survivors {
      name
      age
      gender
      latitude
      longitude
      reports
      infected
    }
  }
  """
  test "survivors fields returns survivors", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivors" => [
          %{
            "name" => "Douglas",
            "age" => 22,
            "gender" => "male",
            "infected" => false,
            "latitude" => "22.392833",
            "longitude" => "22.392833",
            "reports" => 0
          },
          %{
            "name" => "Peter",
            "age" => 25,
            "gender" => "male",
            "infected" => false,
            "latitude" => "30.392833",
            "longitude" => "42.392833",
            "reports" => 0
          }
        ]
      }
    }
  end

  @query """
  {
    survivors(filter: {name: "Doug"}) {
      name
    }
  }
  """
  test "survivors field returns survivors filtered by name", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivors" => [
          %{"name" => "Douglas"}
        ]
      }
    }
  end

  @query"""
  {
    survivors(order: DESC){
      name
    }
  }
  """
  test "survivors field returns survivors descending using literals", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivors" => [
          %{"name" => "Peter"},
          %{"name" => "Douglas"}
        ]
      }
    }
  end

  @query """
  query ($filter: SurvivorFilter!) {
    survivors(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{name: "Doug"}}
  test "survivors field filters by name when using a variable", %{conn: conn} do
    conn = get conn, "/api", query: @query, variables: @variables

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivors" => [
          %{"name" => "Douglas"}
        ]
      }
    }
  end

  @query"""
  query ($order: SortOrder!){
    survivors(order: $order){
      name
    }
  }
  """
  @variables %{"order" => "DESC"}
  test "survivors field returns survivors descending using variables", %{conn: conn} do
    conn = get conn, "/api", query: @query, variables: @variables

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivors" => [
          %{"name" => "Peter"},
          %{"name" => "Douglas"}
        ]
      }
    }
  end

  @query """
  {
    survivors(filter: {name: 123}) {
      name
    }
  }
  """
  test "survivors field returns errors when using a bad value", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert %{
      "errors" => [
        %{"message" => message}
      ]
    } = json_response(conn, 200)
    assert message =~ "Argument \"filter\" has invalid value {name: 123}."
  end
end
