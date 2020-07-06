defmodule ZssnWeb.Schema.Mutation.CreateSurvivorsTest do
  use ZssnWeb.ConnCase, async: true

  setup do
    {:ok, conn: build_conn()}
  end


  @query """
  mutation CreateSurvivor($survivor: SurvivorCreateInput!){
    createSurvivor(input: $survivor){
      errors {
        key
        message
      }
      survivor {
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
          "errors" => nil,
          "survivor" => %{
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
    }
  end

  test "createSurvivor field with inventory creates a survivor and it's survivor_items", %{conn: conn} do
    item = Zssn.Seeds.items() |> List.first()

    survivor = %{
      name: "Chloe",
      age: 14,
      gender: "FEMALE",
      latitude: "22.3245",
      longitude: "35.2394",
      survivor_items: [
        %{item_id: item.id, quantity: 10}
      ]
    }

    conn = post conn, "/api", query: @query, variables: %{"survivor" => survivor}

    assert json_response(conn, 200) == %{
      "data" => %{
        "createSurvivor" => %{
          "errors" => nil,
          "survivor" => %{
            "name" => survivor.name,
            "age" => survivor.age,
            "gender" => survivor.gender,
            "latitude" => survivor.latitude,
            "longitude" => survivor.longitude,
            "infected" => false,
            "inventory" => [%{"itemId" => "#{item.id}", "quantity" => 10}],
            "reports" => 0
          }
        }
      }
    }
  end

  test "createSurvivor field with invalid inventory item_id fails", %{conn: conn} do
    survivor = %{
      name: "Chloe",
      age: 14,
      gender: "FEMALE",
      latitude: "22.3245",
      longitude: "35.2394",
      survivor_items: [
        %{item_id: 200, quantity: 10}
      ]
    }

    conn = post conn, "/api", query: @query, variables: %{"survivor" => survivor}

    assert json_response(conn, 200) == %{
      "data" => %{
        "createSurvivor" => %{
          "errors" => [
            %{"key" => "survivor_items.item_id", "message" => "does not exist"}
          ],
          "survivor" => nil
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

    assert json_response(conn, 200) == %{
      "data" => %{
        "createSurvivor" => %{
          "errors" => [
            %{"key" => "name", "message" => "can't be blank"}
          ],
          "survivor" => nil
        }
      }
    }
  end
end
