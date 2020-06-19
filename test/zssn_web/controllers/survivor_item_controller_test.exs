defmodule ZssnWeb.SurvivorItemControllerTest do
  use ZssnWeb.ConnCase

  alias Zssn.Resources
  alias Zssn.Resources.SurvivorItem

  @create_attrs %{
    quantity: 42
  }
  @update_attrs %{
    quantity: 43
  }
  @invalid_attrs %{quantity: nil}

  def fixture(:survivor_item) do
    {:ok, survivor_item} = Resources.create_survivor_item(@create_attrs)
    survivor_item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all survivor_items", %{conn: conn} do
      conn = get(conn, Routes.survivor_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create survivor_item" do
    test "renders survivor_item when data is valid", %{conn: conn} do
      conn = post(conn, Routes.survivor_item_path(conn, :create), survivor_item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.survivor_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.survivor_item_path(conn, :create), survivor_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update survivor_item" do
    setup [:create_survivor_item]

    test "renders survivor_item when data is valid", %{conn: conn, survivor_item: %SurvivorItem{id: id} = survivor_item} do
      conn = put(conn, Routes.survivor_item_path(conn, :update, survivor_item), survivor_item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.survivor_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, survivor_item: survivor_item} do
      conn = put(conn, Routes.survivor_item_path(conn, :update, survivor_item), survivor_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete survivor_item" do
    setup [:create_survivor_item]

    test "deletes chosen survivor_item", %{conn: conn, survivor_item: survivor_item} do
      conn = delete(conn, Routes.survivor_item_path(conn, :delete, survivor_item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.survivor_item_path(conn, :show, survivor_item))
      end
    end
  end

  defp create_survivor_item(_) do
    survivor_item = fixture(:survivor_item)
    %{survivor_item: survivor_item}
  end
end
