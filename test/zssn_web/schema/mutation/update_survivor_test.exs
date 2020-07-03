defmodule ZssnWeb.Schema.Mutation.UpdateSurvivorsTest do
  use ZssnWeb.ConnCase, async: true

  setup do
    survivors = Zssn.Seeds.survivors()
    {:ok, conn: build_conn(), survivor: List.first(survivors)}
  end


  @query """
  mutation UpdateSurvivor($id: ID!, $survivorParams: SurvivorUpdateInput!){
    updateSurvivor(id: $id, input: $survivorParams){
      errors {
        key
        message
      }
      survivor {
        name
        age
        latitude
        longitude
      }
    }
  }
  """
  @survivorParams %{
    latitude: "120.3245",
    longitude: "90.0716"
  }
  test "updateSurvivor field updates a survivor", %{conn: conn, survivor: survivor} do
    conn = post conn, "/api", query: @query, variables: %{"survivorParams" => @survivorParams, "id" => survivor.id}

    assert json_response(conn, 200) == %{
      "data" => %{
        "updateSurvivor" => %{
          "errors" => nil,
          "survivor" => %{
            "name" => survivor.name,
            "age" => survivor.age,
            "latitude" => @survivorParams.latitude,
            "longitude" => @survivorParams.longitude
          }
        }
      }
    }
  end
end
