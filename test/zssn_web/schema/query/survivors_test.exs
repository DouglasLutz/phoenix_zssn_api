defmodule ZssnWeb.Schema.Query.SurvivorsTest do
  use ZssnWeb.ConnCase

  alias Zssn.Resources.Survivor

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
  test "survivors field returns survivors", %{conn: conn} do
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "survivors" => [
          %{
            "name" => "Douglas",
            "age" => 22,
            "gender" => "MALE",
            "infected" => false,
            "latitude" => "22.392833",
            "longitude" => "22.392833",
            "reports" => 0
          },
          %{
            "name" => "Peter",
            "age" => 25,
            "gender" => "MALE",
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
  query($filter: SurvivorFilter!){
    survivors(filter: $filter){
      name
      insertedAt
    }
  }
  """
  @variables %{filter: %{"insertedBefore" => "2015-01-02"}}
  test "survivors filtered by a custom scalar", %{conn: conn} do
    %Survivor{
        name: "John",
        gender: "male",
        age: 22,
        latitude: 22.392833,
        longitude: 22.392833,
        inserted_at: ~N[2015-01-01 00:00:00]
    } |> Zssn.Repo.insert!

    conn = get conn, "/api", query: @query, variables: @variables
    assert %{
      "data" => %{
        "survivors" => [%{"name" => "John", "insertedAt" => "2015-01-01"}]
      }
    } == json_response(conn, 200)
  end

  @query """
  query($filter: SurvivorFilter!){
    survivors(filter: $filter){
      name
    }
  }
  """
  @variables %{filter: %{"insertedBefore" => "not-a-date"}}
  test "survivors filtered by a custom scalar with error", %{conn: conn} do
    conn = get conn, "/api", query: @query, variables: @variables

    assert %{
      "errors" => [%{
        "message" => message
      }]
    } = json_response(conn, 200)

    expected = """
    Argument "filter" has invalid value $filter.
    In field "insertedBefore": Expected type "Date", found "not-a-date".\
    """

    assert expected == message
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
