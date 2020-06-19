defmodule ZssnWeb.SurvivorItemController do
  use ZssnWeb, :controller

  alias Zssn.Resources
  alias Zssn.Resources.SurvivorItem

  action_fallback ZssnWeb.FallbackController

  def index(conn, _params) do
    survivor_items = Resources.list_survivor_items()
    render(conn, "index.json", survivor_items: survivor_items)
  end

  def create(conn, %{"survivor_item" => survivor_item_params}) do
    with {:ok, %SurvivorItem{} = survivor_item} <- Resources.create_survivor_item(survivor_item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.survivor_item_path(conn, :show, survivor_item))
      |> render("show.json", survivor_item: survivor_item)
    end
  end

  def show(conn, %{"id" => id}) do
    survivor_item = Resources.get_survivor_item!(id)
    render(conn, "show.json", survivor_item: survivor_item)
  end

  def update(conn, %{"id" => id, "survivor_item" => survivor_item_params}) do
    survivor_item = Resources.get_survivor_item!(id)

    with {:ok, %SurvivorItem{} = survivor_item} <- Resources.update_survivor_item(survivor_item, survivor_item_params) do
      render(conn, "show.json", survivor_item: survivor_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    survivor_item = Resources.get_survivor_item!(id)

    with {:ok, %SurvivorItem{}} <- Resources.delete_survivor_item(survivor_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
