defmodule ZssnWeb.Schema.Mutation.CreateSurvivorsTest do
  use ZssnWeb.ConnCase, async: true

  setup do
    {:ok, conn: build_conn()}
  end


  @query """
  mutation CreateSurvivor($survivor: SurvivorInput!){
    createSurvivor(input: $survivor){
      name
      gender
      age
      latitude
      longitude
      inventory{
        quantity
        itemId
      }
      infected
      reports
    }
  }
  """
  @survivor %{
    name: "Chloe",
    age: 14,
    gender: "FEMALE",
    latitude: "22.3245",
    longitude: "35.2394"
  }
  test "createSurvivor field creates a survivor", %{conn: conn} do
    conn = post conn, "/api", query: @query, variables: %{"survivor" => @survivor}

    assert json_response(conn, 200) == %{
      "data" => %{
        "createSurvivor" => %{
          "name" => @survivor.name,
          "age" => @survivor.age,
          "gender" => @survivor.gender,
          "latitude" => @survivor.latitude,
          "longitude" => @survivor.longitude,
          "infected" => false,
          "inventory" => [],
          "reports" => 0
        }
      }
    }
  end

  @survivor %{
    age: 14,
    gender: "FEMALE",
    latitude: "22.3245",
    longitude: "35.2394"
  }
  test "creating a survivor without a name fails", %{conn: conn} do
    conn = post conn, "/api", query: @query, variables: %{"survivor" => @survivor}

    assert %{
      "data" => %{"createSurvivor" => nil},
      "errors" => [%{
        "message" => "Could not create survivor",
        "details" => details
      }]
    } = json_response(conn, 200)

    assert details == %{"name" => ["can't be blank"]}
  end
end
