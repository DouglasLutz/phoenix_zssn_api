defmodule ZssnWeb.SurvivorControllerTest do
  use ZssnWeb.ConnCase

  alias Zssn.Resources
  alias Zssn.Resources.Survivor

  @create_attrs %{
    age: 42,
    gender: "some gender",
    latitude: "120.5",
    longitude: "120.5",
    name: "some name"
  }
  @update_attrs %{
    age: 43,
    gender: "some updated gender",
    latitude: "456.7",
    longitude: "456.7",
    name: "some updated name"
  }
  @invalid_attrs %{age: nil, gender: nil, latitude: nil, longitude: nil, name: nil}

  def fixture(:survivor) do
    {:ok, survivor} = Resources.create_survivor(@create_attrs)
    survivor
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all survivors", %{conn: conn} do
      conn = get(conn, Routes.survivor_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create survivor" do
    test "renders survivor when data is valid", %{conn: conn} do
      conn = post(conn, Routes.survivor_path(conn, :create), survivor: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.survivor_path(conn, :show, id))

      assert %{
               "id" => id,
               "age" => 42,
               "gender" => "some gender",
               "latitude" => "120.5",
               "longitude" => "120.5",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.survivor_path(conn, :create), survivor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update survivor" do
    setup [:create_survivor]

    test "renders survivor when data is valid", %{conn: conn, survivor: %Survivor{id: id} = survivor} do
      conn = put(conn, Routes.survivor_path(conn, :update, survivor), survivor: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.survivor_path(conn, :show, id))

      assert %{
               "id" => id,
               "age" => 43,
               "gender" => "some updated gender",
               "latitude" => "456.7",
               "longitude" => "456.7",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, survivor: survivor} do
      conn = put(conn, Routes.survivor_path(conn, :update, survivor), survivor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "update infection stats when reported", %{conn: conn, survivor: survivor} do
      conn = put(conn, Routes.survivor_path(conn, :report, survivor))
      assert %{
        "reports" => 1,
        "infected" => false
      } = json_response(conn, 200)["data"]

      conn = put(conn, Routes.survivor_path(conn, :report, survivor))
      assert %{
        "reports" => 2,
        "infected" => false
      } = json_response(conn, 200)["data"]

      conn = put(conn, Routes.survivor_path(conn, :report, survivor))
      assert %{
        "reports" => 3,
        "infected" => true
      } = json_response(conn, 200)["data"]
    end
  end


  defp create_survivor(_) do
    survivor = fixture(:survivor)
    %{survivor: survivor}
  end
end
